$(() => {
    $(document).ready(function () {
        $('.check').click(function () {
            $('.check').not(this).prop('checked', false);
        });
    });

    //Assign Click event to Button.
    $("#btnGet").click(function () {
        //Loop through all checked CheckBoxes in GridView.
        $("#dataTable input[type=checkbox]:checked").each(function () {
            const row = $(this).closest("tr")[0];
            const driver_username = row.cells[1].innerHTML.trim();
            const license_plate = row.cells[2].innerHTML.trim();
            const s_location = row.cells[3].innerHTML.trim();
            const e_location = row.cells[4].innerHTML.trim();
            const s_time = row.cells[5].innerHTML.trim();
            const e_time = row.cells[6].innerHTML.trim();
            const s_date = row.cells[7].innerHTML.trim();
            const e_date = row.cells[8].innerHTML.trim();
            const min_bid = row.cells[9].innerHTML.trim();
            const bid_price = $('#bid_price').val();

            const selected_row = {
                driver_username,
                license_plate,
                s_location,
                e_location,
                s_time,
                e_time,
                s_date,
                e_date,
                min_bid,
                bid_price
            };

            //alert(selected_row.driver_username);
            bid(selected_row)
                .then(result => {
                    console.log(result);
                    window.location = '/passenger';
                }).catch(error => {
                    console.error(error);
                    const $errorMessage = $('#errorMessage');
                    $errorMessage.text(error.responseJSON.message);
                    $errorMessage.show();
                    //window.alert("Invalid account");
                });
        });
    });
    //Assign Click event to Button.
    $("#btnGet2").click(function () {
        //Loop through all checked CheckBoxes in GridView.
        $("#dataTable input[type=checkbox]:checked").each(function () {
            const row = $(this).closest("tr")[0];
            const driver_username = row.cells[1].innerHTML.trim();
            const license_plate = row.cells[2].innerHTML.trim();
            const s_location = row.cells[3].innerHTML.trim();
            const e_location = row.cells[4].innerHTML.trim();
            const s_time = row.cells[5].innerHTML.trim();
            const e_time = row.cells[6].innerHTML.trim();
            const s_date = row.cells[7].innerHTML.trim();
            const e_date = row.cells[8].innerHTML.trim();
            const bid_price = row.cells[9].innerHTML.trim();
            const is_won = row.cells[10].innerHTML.trim();

            const selected_row = {
                driver_username,
                license_plate,
                s_location,
                e_location,
                s_time,
                e_time,
                s_date,
                e_date,
                bid_price,
                is_won
            };

            //alert(selected_row.driver_username);
            delete_bid(selected_row)
                .then(result => {
                    console.log(result);
                    window.location = '/passenger';
                }).catch(error => {
                    console.error(error);
                    const $errorMessage = $('#errorMessage');
                    $errorMessage.text(error.responseJSON.message);
                    $errorMessage.show();
                    //window.alert("Invalid account");
                });
        });
    });

    //Assign Click event to Button.
    $("#btnGet3").click(function () {
        //Loop through all checked CheckBoxes in GridView.
        $("#dataTable input[type=checkbox]:checked").each(function () {
            const row = $(this).closest("tr")[0];
            const driver_username = row.cells[1].innerHTML.trim();
            const license_plate = row.cells[2].innerHTML.trim();
            const s_location = row.cells[3].innerHTML.trim();
            const e_location = row.cells[4].innerHTML.trim();
            const s_time = row.cells[5].innerHTML.trim();
            const e_time = row.cells[6].innerHTML.trim();
            const s_date = row.cells[7].innerHTML.trim();
            const e_date = row.cells[8].innerHTML.trim();
            const bid_price = row.cells[9].innerHTML.trim();
            const is_won = row.cells[10].innerHTML.trim();
            const rating = $('#rating').val();

            const selected_row = {
                driver_username,
                license_plate,
                s_location,
                e_location,
                s_time,
                e_time,
                s_date,
                e_date,
                bid_price,
                is_won,
                rating
            };

            //alert(selected_row.driver_username);
            end_trip(selected_row)
                .then(result => {
                    console.log(result);
                    window.location = '/passenger';
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

function bid(selected_row) {
    return $.post('http://localhost:3000/passenger/add', selected_row);
}
function delete_bid(selected_row) {
    return $.post('http://localhost:3000/passenger/delete_bid', selected_row);
}

function end_trip(selected_row) {
    return $.post('http://localhost:3000/passenger/end_trip', selected_row);
}