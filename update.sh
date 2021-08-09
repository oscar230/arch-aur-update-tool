TMP_DIR="/tmp/aur"$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8 ; echo '')
echo "Using dir "$TMP_DIR
mkdir $TMP_DIR
for pkgname in $(sudo -u root pacman -Qqm)
do
    if $(curl -Is "https://aur.archlinux.org/packages/"$pkgname | head -n 1 | grep -q "200"); then
        (cd $TMP_DIR; git clone "https://aur.archlinux.org/"$pkgname".git" -o $pkgname)
        (cd $TMP_DIR"/"$pkgname; makepkg -src -i)
        echo $(cd $TMP_DIR"/"$pkgname; ls -l *.pkg.tar.zst)
    else
        echo $pkgname" is not in the AUR! Is this installed outside of the AUR? Script will skip "$pkgname"."
    fi
done
rm -rf $TMP_DIR