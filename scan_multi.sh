#!/bin/zsh
rm -f temp_packages
for deb in debs/*.deb; do
  echo "Processing $deb"
  dpkg-deb -I "$deb" control | sed '/^ /!d' >> temp_packages
  echo "Filename: $deb" >> temp_packages
  echo "" >> temp_packages
done
mv temp_packages Packages
gzip -k -f Packages
echo "Done. Packages & Packages.gz generated, all versions kept."
