export VERSION := $(shell git describe --tags --abbrev=0 | awk -F. -v OFS=. '{ $$2 = $$2 + 1; $$3 = 0; $$4 = 0; print }')
export GITHUB_REPO := bbombardella/jellyfin-plugin-streamyfin
export FILE := streamyfin-${VERSION}.zip

print:
	echo ${VERSION}

k: zip

zip:
	mkdir -p ./dist
	zip -r -j "./dist/${FILE}" Jellyfin.Plugin.Streamyfin/bin/Release/net9.0/Jellyfin.Plugin.Streamyfin.dll packages/
	cd Jellyfin.Plugin.Streamyfin/bin/Release/net9.0/ && find . -type d -not -path '.' -print | zip -ur "${GITHUB_WORKSPACE}/dist/${FILE}" -@

csum:
	md5sum "./dist/${FILE}"

update-version:
	sed -i 's/\(.*\)<\(.*\)Version>\(.*\)<\/\(.*\)Version>/\1<\2Version>${VERSION}<\/\4Version>/g' Jellyfin.Plugin.Streamyfin/Jellyfin.Plugin.Streamyfin.csproj

test: 
	dotnet test Jellyfin.Plugin.Streamyfin.Tests

build: 
	dotnet build Jellyfin.Plugin.Streamyfin --configuration Release

release: print update-version build zip
