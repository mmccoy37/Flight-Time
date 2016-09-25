$(document).ready(function(){

    var origin1 = $("#loc-end-id").val();
    var destinationA = '6000 N Terminal Pkwy, Atlanta, GA 30320';
    // var formdata = $("#flightform").serialize();
    var flightnum = document.getElementById("flightnum").value;
    var flightdate = document.getElementById("flightdate").value;
    var duration;
    var pos;

    $("#gpsBtn").click(function(){
      navigator.geolocation.getCurrentPosition(function(position) {
             pos = {
              lat: position.coords.latitude,
              lng: position.coords.longitude
            };
            origin1 = pos;
            console.log(pos);

            var geocoder = new google.maps.Geocoder;
            console.log(pos);
            var myLocal = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
            geocoder.geocode({'location': myLocal}, function(results, status) {
              if (status === 'OK') {
                var address = results[0];
                console.log(address.formatted_address);
                $("#loc-end-id").val(address.formatted_address);
              } else {
                console("We were not able to parse this into a real address");
              }
            });
          });

    });

    $("#submit").click(function(){
        $('#result-panel').html("")
        document.getElementById("spinner-div").style.visibility = "visible";
        // AJAX CALL TO GET LATLNG FOR GOOGLE MAPS CALCULATION
        $.ajax({
            type: 'post',
            url: "/city",
            data: {
                flightdate: flightdate,
                flightnum: flightnum,
            },
            success: function(result){
                var destinationB = new google.maps.LatLng(result.lat, result.long);
                var destinationC = new google.maps.LatLng(50.087692, 14.421150);
                // start google maps stuff
                var service = new google.maps.DistanceMatrixService;
                service.getDistanceMatrix({
                    origins: [origin1],
                    destinations: [destinationB],
                    travelMode: 'DRIVING',
                    avoidHighways: false,
                    avoidTolls: true,
                },
                function(response, status) {
                    if(status=="OK") {
                        var element = response.rows[0];
                        duration = element.elements[0];
                        // get detailed flight timing info with map info passed into it
                        $.ajax({
                            type: 'POST',
                            url: "/result",
                            data: {
                                flightdate: flightdate,
                                flightnum: flightnum,
                                mapdelay: duration
                            },
                            success: function(result){
                                document.getElementById("spinner-div").style.visibility = "hidden";
                                $('#result-panel').html(result)
                            }
                        })
                    } else {
                        alert("Error: " + status);
                    }
                });
            }
        })
    })
})
