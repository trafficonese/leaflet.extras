// node ./scripts/license_checker.js > LICENSE.note

var checker = require('license-checker');
var fs = require('fs');

var pkg = require('./../package.json');

var _ = require('lodash');


checker.init(
  {
    start: '.'
  },
  function(err, license_json) {
    if (err) {
      //Handle error
      console.log(err);
      return err;
    }
    for_every_prod_package = function(fn) {
      var pkg_name, pkg_title, pkg_info;
      for (pkg_name in license_json) {
        pkg_title = pkg_name.replace(/\@\d+\.\d+\.\d+$/, "");
        if (_.has(pkg.dependencies, pkg_title)) {
          pkg_info = license_json[pkg_name];
          fn(pkg_name, pkg_info, pkg_title);
        }
      }
    }

    console.log("The leaflet.extras package as a whole is distributed under GPL-3 (GNU GENERAL PUBLIC LICENSE version 3).\n\nThe leaflet.extras package includes other open source software components. The following\nis a list of these components (full copies of the license agreements used by\nthese components are included below):");
    console.log("");

    //The sorted json data
    // console.log(json);
    for_every_prod_package(function(pkg_name, pkg_info, pkg_title) {
      console.log(" -", pkg_name, "-", pkg_info.licenses, "-", pkg_info.repository);
    });
    console.log("\n\n\n");
    for_every_prod_package(function(pkg_name, pkg_info, pkg_title) {
      console.log(pkg_name, "-", pkg_info.licenses, "-", pkg_info.repository);
      console.log("----------------------------------------------------");
      file_info = fs.readFileSync(pkg_info.licenseFile, 'utf8');
      console.log(file_info);
      console.log("\n\n\n\n");
    });
  }
);
