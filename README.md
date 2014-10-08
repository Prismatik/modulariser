# Modulariser

This is a utility to take a set of content files and:

1. Upload them to an API
2. Create a manifest from them
3. Upload that to an API

## Installation

clone this repository, then

`npm install && npm link`

## Usage

### To create a new module id

`API=http://localhost:3000/api/v1 modulariser_new MODULENAME OPTIONAL_VERSION`

Where:

* The paramater passed to the API environment variable is the location of the API you are interacting with
* MODULENAME is the friendly name you wish to assign to your new module
* OPTIONAL_VERSION may be omitted and defaults to '0'

### To update a module

cd to the directory containing your content and:

`API=http://localhost:3000/api/v1 modulariser_update MODULEID VERSION OPTIONAL_FORCE`

Where:

* The paramater passed to the API environment variable is the location of the API you are interacting with
* MODULEID is the ID of the module you are updating
* VERSION is the version string you wish to update it to
* OPTIONAL_FORCE is a boolean corresponding to whether you wish to force an update. If it looks like you're doing something silly like updating to a version older than the current tip, modulariser will warn you and refuse to proceed, unless force is true
