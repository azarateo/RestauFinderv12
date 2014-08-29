<?php

  require_once '../application/DB_Connect.php';
  require_once '../controllers/ControllerRest.php';
  $controllerRest = new ControllerRest();

  $resultRestaurants = $controllerRest->getRestaurantsResult();
  $resultCategories = $controllerRest->getCategoriesResult();
  $resultPhotos = $controllerRest->getPhotosResult();

  
  // header ("content-type: text/xml");
  header("Content-Type: application/xml; charset=ISO-8859-1");
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
  echo "<data>";

      // RESTAURANTS
      echo "<restaurants>";
      foreach ($resultRestaurants as $row) 
      {
          echo"<item>";
          foreach ($row as $columnName => $field) 
          {
            $field = str_replace("&#039;", "'", $field);
            if(!is_numeric($columnName)) {
                echo "<$columnName>$field</$columnName>";
            }
          }
          echo"</item>";
      }
      echo "</restaurants>";
      

      // CATEGORIES
      echo "<categories>";
      foreach ($resultCategories as $row) 
      {
          echo"<item>";
          foreach ($row as $columnName => $field) 
          {
            $field = str_replace("&#039;", "'", $field);
            if(!is_numeric($columnName)) {
                echo "<$columnName>$field</$columnName>";
            }
          }
          echo"</item>";
      }
      echo "</categories>";


      // PHOTOS
      echo "<photos>";
      foreach ($resultPhotos as $row) 
      {
          echo"<item>";
          foreach ($row as $columnName => $field) 
          {
            $field = str_replace("&#039;", "'", $field);
            if(!is_numeric($columnName)) {
                echo "<$columnName>$field</$columnName>";
            }
          }
          echo"</item>";
      }
      echo "</photos>";
  
  echo "</data>";

?>