<?php

 
class ControllerRest
{
 
    private $db;
    private $pdo;
    function __construct() 
    {
        // connecting to database
        $this->db = new DB_Connect();
        $this->pdo = $this->db->connect();
    }
 
    function __destruct() { }
 
    public function getRestaurantsResult() 
    {
        $stmt = $this->pdo->prepare('SELECT * FROM tbl_restaurants_restaurants WHERE is_deleted = 0');

        $stmt->execute();
        return $stmt;
    }

    public function getCategoriesResult() 
    {
        $stmt = $this->pdo->prepare('SELECT * FROM tbl_restaurants_categories WHERE is_deleted = 0');
        $stmt->execute();
        return $stmt;
    }

    public function getPhotosResult() 
    {
        $stmt = $this->pdo->prepare('SELECT * FROM tbl_restaurants_photos WHERE is_deleted = 0');
        $stmt->execute();
        return $stmt;
    }


}
 
?>