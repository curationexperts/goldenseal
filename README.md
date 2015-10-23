# Goldenseal -- _Hydrastis canadensis_
[![Build Status](https://travis-ci.org/curationexperts/goldenseal.svg?branch=master)](https://travis-ci.org/curationexperts/goldenseal)

## Installation

### Prerequisites:

* Goldenseal relies on [hydra-derivatives](https://github.com/projecthydra/hydra-derivatives) for derivative processing and needs the [required dependencies](https://github.com/projecthydra/hydra-derivatives#dependencies) installed
* redis

```
bin/setup
rake jetty:clean
rake curation_concerns:jetty:config
rake jetty:start
```

### Config:

* Configure ```config/initializers/curation_concerns.rb```

## Background Jobs

To start the redis server:
```
redis-server /usr/local/etc/redis.conf
```

To see the status of recent jobs in the browser console:
```
resque-web -N curation_concerns:development
```

To start worker(s) to run the jobs:
```
QUEUE=* VERBOSE=1 rake resque:work
```

## Run the test suite

* Make sure jetty is running
* `bundle exec rake spec`

## Run the rails server

* Make sure jetty is running
* Make sure redis is running
* `bin/rails s`

## Importing Records
### Importing records with TEI or VRA files

TEI files can be parsed to create Audio, Video, or Text records.  VRA records can be parsed to produce Image records.  The instructions are basically the same either way.

* Create a directory and add all the TEI (or VRA) files to that directory.
* Add all the attached files to the same directory.  You can organize them in sub-directories if you wish; They don't need to be in the top-level directory.
* From within the Rails root directory, run the import script:

```
script/import -t TYPE -p PATH -v [VISIBILITY] -a [ADMIN_SET_ID]
```

| Argument | Description | Requirement |
| --- | --- | --- |
| -t | The type of record(s) to create.  Valid options are: ["Text", "Video", "Audio", "Image"]. | required |
| -p | The path to the directory where the TEI or VRA files are located. | required |
| -v | The visibility level that the imported records will have.  Valid options are: ["open", "institution", "private"].  Default value will be "private" if no option is given. | optional |
| -a | The ID for the AdminSet that the imported records will belong to.  If no option is given, the imported records will not belong to any AdminSet. | optional |
| -h | Help: Print usage message for this script | optional |

**Note:**  The TEI files must be at the top level of the directory and must have a `.xml` file extension.  The importer will assume that any XML files found in the top-level directory are TEI files, and try to parse them.  The same is true for VRA records.

**Note:** Visibility cannot be set to `embargo` or `lease` using this script.  If you want to create a record with an embargo or lease, please import the record with `private` visibility, then edit the record using the UI to set the embargo manually.

To see the list of IDs for all AdminSets, run the rake task:

```
rake admin_set:list
```

