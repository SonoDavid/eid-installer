#! /usr/bin/python

import apt
import sys
import gi
import subprocess

gi.require_version("Gtk", "3.0")
from gi.repository import GLib, Gtk, Gio

# This would typically be its own file
MENU_XML = """
<?xml version="1.0" encoding="UTF-8"?>
<interface>
<menu id="menubar">
    <submenu>
        <attribute name="label">Over</attribute>
        <section>
            <item>
                <attribute name="action">app.about</attribute>
                <attribute name="label">Over</attribute>
            </item>
        </section>
    </submenu>
</menu>
</interface>
"""


class AppWindow(Gtk.ApplicationWindow):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.set_default_size(500, 300)

        self.props.show_menubar = True

        self.box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(self.box)

        self.create_label(text="  Volg deze twee stappen om de eID software te installeren op Linux Mint")
        self.create_label(text="1. Installeer het pakket \"eID-archive\", zodat de eID pakketrepositories beschikbaar worden.")

        self.eid_archive_button = self.create_my_button("Installeer eID-archive", self.install_repo_clicked)

        self.create_label(text="2. Installeer de \"eid-viewer\" en \"eid-mw\" pakketten") 

        self.eid_software_button = self.create_my_button("Installed eID viewer en middleware", self.install_eid_clicked)
        self.info_label = self.create_label("")
        self.check_button_states()

    def create_label(self, text):
        label = Gtk.Label(label="  " + text) 
        label.set_halign(Gtk.Align.START)
        self.box.add(label)
        return label

    def create_my_button(self, label, function):
        button = Gtk.Button(label=label)
        button.connect("clicked", function)
        button.set_margin_start(150)
        button.set_margin_end(150)
        self.box.add(button)
        return button

    def install_repo_clicked(self, widget):
        process = subprocess.run(["wget","-O","eid-archive_latest.deb","https://eid.belgium.be/sites/default/files/software/eid-archive_latest.deb"])
        if process.returncode == 0:
            subprocess.run(["/bin/bash", "captain", "eid-archive_latest.deb"])
        subprocess.run(["rm","eid-archive_latest.deb"])
        self.check_button_states()

    def install_eid_clicked(self, widget):
        subprocess.run(["/bin/bash", "captain", "apt://eid-viewer,eid-mw"])
        self.check_button_states()

    def check_button_states(self):
        cache = apt.Cache()
        archive_installed = "eid-archive" in cache and cache["eid-archive"].installed
        self.eid_archive_button.set_sensitive(not archive_installed)
        software_pkgs_installed = all(
            package_name in cache and cache[package_name].installed
            for package_name in ["eid-mw", "eid-viewer"]
        )
        self.eid_software_button.set_sensitive(archive_installed and not software_pkgs_installed)
        if software_pkgs_installed:             
            self.info_label.set_markup(
                "<big><b>De eID software is geïnstalleerd</b></big>\r"
                "Open het programma '<b>eID Kaartlezer</b>' in je hoofdmenu.\r"
                ' • Installeer indien nodig de <a href="https://addons.mozilla.org/nl/firefox/addon/belgium-eid">Firefox Addon</a>.\r'
                ' • Op deze site kan je je <a href="https://iamapps.belgium.be/tma/" >kaartlezer testen</a>'
            )
            self.info_label.set_margin_start(50)
        self.show_all()


class Application(Gtk.Application):
    def __init__(self, *args, **kwargs):
        super().__init__(
            *args,
            application_id="org.example.App",
            **kwargs,
        )
        self.window = None

    def do_startup(self):
        Gtk.Application.do_startup(self)

        action = Gio.SimpleAction.new("about", None)
        action.connect("activate", self.on_about)
        self.add_action(action)

        action = Gio.SimpleAction.new("quit", None)
        action.connect("activate", self.on_quit)
        self.add_action(action)

        builder = Gtk.Builder.new_from_string(MENU_XML, -1)
        self.set_menubar(builder.get_object("menubar"))

    def check_software_pkgs_installed(self):
        cache = apt.Cache()
        software_pkgs_installed = all(
            package_name in cache and cache[package_name].installed
            for package_name in ["eid-mw", "eid-viewer"]
        )
        return software_pkgs_installed
        

    def do_activate(self):
        # We only allow a single window and raise any existing ones
        if not self.window:
            # Windows are associated with the application
            # when the last one is closed the application shuts down
            self.window = AppWindow(application=self, title="Installatie eID kaartlezer")

        self.window.present()

    def on_about(self, _action, _param):
        about_dialog = Gtk.AboutDialog(transient_for=self.window, modal=True)
        about_dialog.set_program_name("Installatie eID kaartlezer")
        about_dialog.set_comments("Programma om de Belgische eID software op Linux Mint te installeren")        
        about_dialog.set_authors(["Joachim David (repairit@tuta.com)"])
        about_dialog.set_license_type(Gtk.License.GPL_3_0)
        about_dialog.present()

    def on_quit(self, _action, _param):
        self.quit()


if __name__ == "__main__":
    print("The GUI for Linux Mint will install the eID middleware and eID viewer for Ubuntu.\nIt will download the debian package from https://eid.belgium.be/sites/default/files/software/eid-archive_latest.deb and install it on your computer. Furthermore, you can install the eID Viewer and Middleware.")    
    app = Application()
    app.run(sys.argv)
