===================================
RetroArch Windows megapack 20140103
===================================

===========
Changelog
===========

20140103:
   - ...

20131013:
   - RGUI has gotten a face lift in user friendliness.
     * On first startup, a start screen is shown with the basic hotkeys for RGUI.
       This should help new users use RGUI.
     * Gamepad configuration can now be done from within RGUI. Not all hotkeys are exposed, but the most important ones are.
     * The .info-file concept from OSX/iOS ports of RetroArch have been made mainline.
       These files contain basic metadata which helps RGUI be more user friendly.
       - When choosing libretro cores, more friendly names are shown instead of the raw dll paths.
       - Load Game (Detect Core) is added to the menu.
         This allows you do choose a ROM directly without having to switch the libretro core first.
         If multiple cores can match to the extension, a list will be presented with relevant cores.
         Even .zip files are supported in this way, as it will try to match against files within the zip.


====================================
General notes about the megapack (if you've used RetrArch before)
====================================

*Seriously* avoid these things:
- bSNES CPU filters (cannot be set from RGUI).
- XML shaders (cannot be set from RGUI).
- Phoenix GUI (deprecated, it should die).

If you absolutely *must* use these, you can set CPU filters and XML shaders in config.
They are very troublesome and ugly features.
They will not be supported in RGUI.

Phoenix GUI is not included. It is deprecated, breaks with xinput and should in general be avoided.
All config options are still available obviously. See retroarch.cfg.
If retroarch.cfg gets overwritten, see retroarch.cfg.clean for the default skeleton config. All relevant config options are explained.

All Phoenix features have their equivalent in either command line or config. It's just a launcher, it doesn't to anything magical.
See retroarch.exe --help.
Some RetroArch features like special ROM loading, netplay and ffmpeg recording are all accessible from CLI.
These features will probably eventually be added to RGUI, but it's not top priority.

===============
libretro cores
===============

I've included all cores which built from libretro-super as of 20131013 with MinGW-w64 4.8.1 POSIX thread.
They're placed in libretro/ directory.

Note that many of these cores are WIP-quality, and some are outright broken.

=========
Shaders
=========

I've bundled all shaders from common-shaders/ repo.

=====================
Input configuration
=====================

If you have an xinput-supported gamepad, you should not need to configure input at all. It should work as expected.

-----
RGUI
-----

You can do basic gamepad configuration within RGUI. Use Configure All to configure everything in one go. You can also bind the RGUI menu toggle.
Keyboard configuration inside RGUI is not supported yet.

----
CLI
----

If you want to configure input for obscure systems which don't map well to the RetroPad,
it is recommended you create an autoconfig for your device.

    retroarch-joyconfig.exe -a autoconfig/yourpad.cfg

Follow the instructions on-screen.

You can also configure input directly and update retroarch.cfg, but this is not recommended.
The reasoning is that you have to create configs per player if you have two or more of the same pad.
You also have to duplicate input configs if you have multiple configs which use the same config.
Autoconfigs can help avoid duplication in these cases.

   retroarch-joyconfig.exe -i retroarch.cfg -o retroarch.cfg

To configure some of the most relevant hotkeys (save state/load state/RGUI menu toggle), add --misc.
If you don't want to configure certain binds, there is no way to "skip" a config. A workaround for this is to use the --timeout option.
See retroarch-joyconfig.exe --help for more information.

=========
Logging
=========

To get logging in terminal:
    retroarch.exe -v --menu

Dump log to a file:
    retroarch.exe -v --menu 2>log.txt

================
Custom configs
================

Recently, support for changing config within RGUI was added.
You can also create new configs for complete flexibility.

If you want to go completely nuts with custom input autoconfig dirs, history lists, etc per config, you'll have to hack in the config. As always, see retroarch.cfg.clean for reference.

=================
Notes on config
=================

I've set libretro config, system directory, shader directory, screenshot directory and config directory.
Note that I've used ":/libretro/". The : prefix is a special prefix which means relative to the retroarch.exe.
Relative paths would normally work fine, but in case the working dir is ever changed, it would break this.
When the config is saved back, it'll probably have the actual full path, so beware of that.

config_save_on_exit = true
is also set, so the config will automatically be saved on exit by default.

==========================
System directory / BIOS
==========================
System directory is ./system/. I've put bSNES stuff in there as well as mupen64 .ini files.
Provide your own BIOSes as needed.

