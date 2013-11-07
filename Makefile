USE_PKGBUILD=1
include /usr/local/share/luggage/luggage.make

BOX_EDIT_INSTALLER_URL=http://www.box.com/static/BoxEdit/BoxEditInstaller.dmg

TITLE=BoxEdit
REVERSE_DOMAIN=com.box
PACKAGE_ID=${REVERSE_DOMAIN}.Box-Edit-Installer

PACKAGE_VERSION=1.2.2

PAYLOAD=\
	attach-BoxEditInstaller.dmg \
	pack-from-dmg-BoxEditApp \
	pack-from-dmg-BoxEditPlugin \
	detach-BoxEditInstaller.dmg \
	pack-Library-LaunchAgents-com.box.BoxEditLaunch.plist \
	pack-script-postinstall


BoxEditInstaller.dmg:
	${CURL} --location --output $@ ${BOX_EDIT_INSTALLER_URL}

attach-%: %
	@mkdir -p /tmp/$(<:%.dmg=%)
	${HDIUTIL} attach $< -mountpoint /tmp/$(<:%.dmg=%) -nobrowse -noverify -noautoopen

detach-%: %
	@${HDIUTIL} detach /tmp/$(<:%.dmg=%) -force
	@${RM} -rf /tmp/$(<:%.dmg=%)

pack-from-dmg-BoxEditApp: l_Applications
	@sudo ${DITTO} --noqtn /tmp/BoxEditInstaller/Install\ Box\ Edit.app/Contents/Resources/Box\ Edit.app \
		${WORK_D}/Applications/Box\ Edit.app
	@sudo chown -R root:admin ${WORK_D}/Applications/Box\ Edit.app
	@sudo chmod 755 ${WORK_D}/Applications/Box\ Edit.app

pack-from-dmg-BoxEditPlugin: l_Library_Internet_Plug-Ins
	@sudo ${DITTO} --noqtn /tmp/BoxEditInstaller/Install\ Box\ Edit.app/Contents/Resources/Box\ Edit.plugin \
		${WORK_D}/Library/Internet\ Plug-Ins/Box\ Edit.plugin
	@sudo chown -R root:admin ${WORK_D}/Applications/Box\ Edit.app
	@sudo chmod 755 ${WORK_D}/Applications/Box\ Edit.app
