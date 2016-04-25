#!/bin/bash

# .../tex/ is ... something

cd /home/vagrant/
cp -r /vagrant/tex/ .

# TODO: a comment about why we merge

pushd /home/vagrant/EOASkripts/
git checkout vagrant
git merge origin/dev-ou-marginalia -m "automatic merge"
grep newcommand TeX/pre_eoa.tex | grep EOAmn || echo '\newcommand{\EOAmn}[1]{\marginpar{#1}}' >> TeX/pre_eoa.tex
popd


cd tex
ln -s ../EOASkripts/TeX/pre_eoa.tex
ln -s ../EOASkripts/TeX/pre_xml.tex
cp twocol.tex before
sed s/eoa/xml/ before > after
xelatex twocol
biber twocol
xelatex twocol
cp after twocol.tex

. /srv/skriptenv/bin/activate
rm -r html/ iso8879/ iso9573-13/ mathml/ mathml2/
mkdir -p ./tmp/
#ln -s 
TMPDIR=./tmp/ python ../EOASkripts/Skripten/EOAconvert.py -f twocol
deactivate

cd /home/vagrant/eoa-django/eoa/website/
git checkout dev-ou-vagrant
git merge origin/dev-ou-marginalia -m "automatic merge"
mkdir -p website/import/
cp /home/vagrant/tex/CONVERT/django/Django.xml website/import/
cp /vagrant/tex/CONVERT/Cover.jpg website/import/
cp /vagrant/tex/CONVERT/publication.cfg website/import/
. /srv/venv/bin/activate
python manage.py publicationimport
deactivate
