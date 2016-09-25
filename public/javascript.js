$(document).ready(function(){

  var origin1 = $("#loc-end-id").val();
  var destinationA = '6000 N Terminal Pkwy, Atlanta, GA 30320';

    $("#submit").click(function(){
        $('#result-panel').html("")
        document.getElementById("spinner-div").style.visibility = "visible";

        $.ajax({
            type: 'POST',
            url: "/result",
            data: $("#flightform").serialize(),
            success: function(result){
                document.getElementById("spinner-div").style.visibility = "hidden";
                $('#result-panel').html(result)
            }
        })

        var service = new google.maps.DistanceMatrixService;
        service.getDistanceMatrix(
          {
            origins: [origin1],
            destinations: [destinationA],
            travelMode: 'DRIVING',
            avoidHighways: false,
            avoidTolls: true,
          },

          function(response, status) {

            if(status=="OK") {
              console.log("ITWORKED");
              console.log(response);
              var element = response.rows[0];
              console.log(element);
              var duration = element.elements[0];
              console.log(duration.duration.text);

            } else {
                alert("Error: " + status);
            }
          });
    })
})
