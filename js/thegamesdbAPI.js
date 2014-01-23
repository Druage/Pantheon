function requestXML() {
            var api = "http://thegamesdb.net/api/GetGame.php?id=2";
            xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", api);
            xmlhttp.send();
            xmlDoc=xmlhttp.reponseXML;
            console.log(xmlDoc);
        }
