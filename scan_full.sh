#!/bin/zsh
rm -f temp_packages
for deb in debs/*.deb; do
  echo "Processing $deb"
  SIZE=$(stat -f%z "$deb")
  MD5=$(md5 -q "$deb")
  SHA1=$(shasum -a1 "$deb" | awk '{print $1}')
  SHA256=$(shasum -a256 "$deb" | awk '{print $1}')

  dpkg-deb -I "$deb" control | sed '/^ /!d' >> temp_packages
  echo "Filename: $deb" >> temp_packages
  echo "Size: $SIZE" >> temp_packages
  echo "MD5sum: $MD5" >> temp_packages
  echo "SHA1: $SHA1" >> temp_packages
  echo "SHA256: $SHA256" >> temp_packages
  echo "" >> temp_packages
done
mv temp_packages Packages
gzip -k -f Packages
echo "Full Packages with hash generated."
