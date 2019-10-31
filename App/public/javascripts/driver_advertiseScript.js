$(() => {
    $(document).ready(function(){
        $('.check').click(function() {
            $('.check').not(this).prop('checked', false);
        });
    });

    //Assign Click event to Button.
    $("#btnGet2").click(function () {
        //Loop through all checked CheckBoxes in GridView.
        $("#dataTable input[type=checkbox]:checked").each(function () {
            const row = $(this).closest("tr")[0];
            const s_date = row.cells[1].innerHTML;
            const e_date = row.cells[2].innerHTML;
            const s_time = row.cells[3].innerHTML;
            const e_time = row.cells[4].innerHTML;
            const s_location = row.cells[5].innerHTML;
            const e_location = row.cells[6].innerHTML;
            const license_plate = row.cells[7].innerHTML;
            const min_bid = row.cells[8].innerHTML; 
            
            const selected_row = {
                s_date,
                e_date,
                s_time,
                e_time,
                s_location,
                e_location,
                license_plate,
                min_bid,
             };
             
            //alert(selected_row.driver_username);
            delete_advertise(selected_row)
            .then(result => {
                console.log(result);
                window.location = '/driver_advertise';
            }).catch(error => { 
                console.error(error);
                const $errorMessage = $('#errorMessage');
                $errorMessage.text(error.responseJSON.message);
                $errorMessage.show(); 
                //window.alert("Invalid account");
            });
        });
    });
});

function delete_advertise(selected_row) {
return $.post('http://localhost:3000/driver_advertise/delete_advertise', selected_row);
}