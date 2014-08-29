

#ifndef RestaurantLocator_Config_h
#define RestaurantLocator_Config_h


// Change this to YES or No to change format data using JSON or XML
// NO means XML data format
// YES means JSON data format
#define WILL_USE_JSON_FORMAT NO


// URL of the json file
#define DATA_JSON_URL @"http://mangasaurgames.com/apps/restau-v1.2/rest/data_json.php"

// URL of the xml file
#define DATA_XML_URL @"http://mangasaurgames.com/apps/restau-v1.2/rest/data_xml.php"


#define WILL_DOWNLOAD_DATA YES

#define CATEGORY_ALL @"All"


#define INNER_TAB_TITLE [NSArray arrayWithObjects:@"Details", @"Map", @"Gallery", nil]

#endif
