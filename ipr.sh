#!/bin/bash

sudo chroot /home/xf0r3m/build/stable/immudex/64/chroot /bin/bash get_preformated_upgradable_list.sh stable > /tmp/stable-apt-upgradable-preformated.list;
sudo chroot /home/xf0r3m/build/stable/immudex/64/chroot /bin/bash get_preformated_installed_list.sh stable > /tmp/stable-apt-installed-preformated.list;
sudo chroot /home/xf0r3m/build/testing/immudex-testing/64/chroot /bin/bash get_preformated_upgradable_list.sh testing > /tmp/testing-apt-upgradable-preformated.list;
sudo chroot /home/xf0r3m/build/testing/immudex-testing/64/chroot /bin/bash get_preformated_installed_list.sh testing > /tmp/testing-apt-installed-preformated.list;
sudo chroot /home/xf0r3m/build/lhe/immudex-lhe/32/chroot /bin/bash get_preformated_upgradable_list.sh oldoldstable > /tmp/lhe-apt-upgradable-preformated.list;
sudo chroot /home/xf0r3m/build/lhe/immudex-lhe/32/chroot /bin/bash get_preformated_installed_list.sh oldoldstable > /tmp/lhe-apt-installed-preformated.list;

function checkPackage() {

	if grep -q "^${1}\ " /tmp/${2}-apt-upgradable-preformated.list; then
		version=$(grep "^${1}\ " /tmp/${2}-apt-upgradable-preformated.list | cut -d " " -f 2-);
		color="#ff0000";
	else
		version=$(grep "^${1}\ " /tmp/${2}-apt-installed-preformated.list | cut -d " " -f 2-);
		color="#15ed15";
	fi
	echo "$version $color";

}

list=$(awk '{printf $1" "}' list.txt);
echo "<h2>Lista pakietów oprogramowania</h2>" > packages_list.html;
echo "<p>Stan pakietów i aktualizacji na: <strong>$(date)</strong></p>" >>packages_list.html;
echo "<table border=\"1\" style=\"border-collapse: collapse\">" >> packages_list.html;
echo "<tr><th>Nazwa pakietu</th><th>stable</th><th>testing</th><th>LHE*</th></tr>" >> packages_list.html;
for package in $list; do
	echo "<tr>" >> packages_list.html;
	s_veracol=$(checkPackage $package stable);
	s_version=$(echo $s_veracol | cut -d " " -f 1);
	s_color=$(echo $s_veracol | cut -d " " -f 2);
	t_veracol=$(checkPackage $package testing);
	t_version=$(echo $t_veracol | cut -d " " -f 1);
	t_color=$(echo $t_veracol | cut -d " " -f 2);
  l_veracol=$(checkPackage $package lhe);
  l_version=$(echo $l_veracol | cut -d " " -f 1);
  l_color=$(echo $l_veracol | cut -d " " -f 2);
	if $(echo "$s_version" | grep -q '^#'); then s_version="N/I"; s_color="inherit"; fi
  if $(echo "$t_version" | grep -q '^#'); then t_version="N/I"; t_color="inherit"; fi	
  if $(echo "$l_version" | grep -q '^#'); then l_version="N/I"; l_color="inherit"; fi	
	#if [ "$package" = "linux-image-amd64" ] || [ "$package" = "linux-image-686" ]; then package="linux-image"; fi;
	echo "<td>${package}</td>" >> packages_list.html;
	echo "<td><span style=\"color: ${s_color}\">${s_version}</span></td>" >> packages_list.html;
	echo "<td><span style=\"color: ${t_color}\">${t_version}</span></td>" >> packages_list.html;
  echo "<td><span style=\"color: ${l_color}\">${l_version}</span></td>" >> packages_list.html;
	echo "</tr>" >> packages_list.html;
done
echo "</table>" >> packages_list.html;
echo "<p>" >> packages_list.html;
echo "<em>* - Low Hardware Edition, Debian 10 Buster, 32-bit</em><br />" >> packages_list.html;
echo "<strong>N/I</strong> - (ang. <em>Not installed</em>) - nie zainstalowano<br />" >> packages_list.html;
echo "<span style=\"display: block; width: 15px; height: 15px; background-color: #15ed15; float: left;\"></span>&nbsp;- zainstalowana wersja<br />" >> packages_list.html; 
echo "<span style=\"display: block; width: 15px; height: 15px; background-color: #ff0000; float: left;\"></span>&nbsp;- wersja gotowa do instalacji (aktualizacja)<br />" >> packages_list.html;
echo "</p>" >> packages_list.html;
sed -n '1,21p' template.html > index.html;
cat packages_list.html >> index.html;
sed -n '21,$p' template.html >> index.html;
sudo cp index.html /var/www/html;
