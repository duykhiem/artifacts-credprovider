#!/usr/bin/env bash
# DESCRIPTION: A simple shell script designed to fetch a version
# of the artifacts credential provider plugin and install it into $HOME/.nuget/plugins.
# Readme: https://github.com/Microsoft/artifacts-credprovider/blob/master/README.md

# Default version to install is the latest version.
# To install a release other than `latest`, set the `AZURE_ARTIFACTS_CREDENTIAL_PROVIDER_VERSION` environment
# variable to match the TAG NAME of a supported release, e.g. "v0.1.28".
# Releases: https://github.com/microsoft/artifacts-credprovider/releases

# To install the NET6 credential provider instead of the default, NetCore3.1, 
# set the `USE_NET6_ARTIFACTS_CREDENTIAL_PROVIDER` environment variable.

REPO="Microsoft/artifacts-credprovider"
NUGET_PLUGIN_DIR="$HOME/.nuget/plugins"

FILE=" Microsoft.NetCore3.NuGet.CredentialProvider.tar.gz"

# If AZURE_ARTIFACTS_CREDENTIAL_PROVIDER_VERSION is set, install the version specified, otherwise install latest
if [[ ! -z ${AZURE_ARTIFACTS_CREDENTIAL_PROVIDER_VERSION} ]] && [[ ${AZURE_ARTIFACTS_CREDENTIAL_PROVIDER_VERSION} != "latest" ]]; then
  # browser_download_url from https://api.github.com/repos/Microsoft/artifacts-credprovider/releases/latest 
  URI="https://github.com/$REPO/releases/download/${AZURE_ARTIFACTS_CREDENTIAL_PROVIDER_VERSION}/$FILE"
else
  # URL pattern to get latest documented at https://help.github.com/en/articles/linking-to-releases as of 2019-03-29
  URI="https://github.com/$REPO/releases/latest/download/$FILE"
fi

# Ensure plugin directory exists
if [ ! -d "${NUGET_PLUGIN_DIR}" ]; then
  echo "INFO: Creating the nuget plugin directory (i.e. ${NUGET_PLUGIN_DIR}). "
  if ! mkdir -p "${NUGET_PLUGIN_DIR}"; then
      echo "ERROR: Unable to create nuget plugins directory (i.e. ${NUGET_PLUGIN_DIR})."
      exit 1
  fi
fi

echo "Downloading from $URI"
# Extract netcore from the .tar.gz into the plugin directory

#Fetch the file
curl -H "Accept: application/octet-stream" \
     -s \
     -S \
     -L \
     "$URI" | tar xz -C "$HOME/.nuget/" "plugins/netcore"

echo "INFO: credential provider netcore plugin extracted to $HOME/.nuget/"
