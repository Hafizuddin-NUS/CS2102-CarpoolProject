$(() => {
    $(function () {
        //Assign Click event to Button.
        $("#btnGet").click(function () {
            var message = "Id Name                  Country\n";
 
            //Loop through all checked CheckBoxes in GridView.
            $("#Table1 input[type=checkbox]:checked").each(function () {
                var row = $(this).closest("tr")[0];
                message += row.cells[1].innerHTML;
                message += "   " + row.cells[2].innerHTML;
                message += "   " + row.cells[3].innerHTML;
                message += "\n";
            });
 
            //Display selected Row data in Alert Box.
            alert(message);
            return false;
        });
    });
});