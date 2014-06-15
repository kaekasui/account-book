$("select#record_breakdown_id").children().remove()
$("select#record_breakdown_id").html('<%= options_for_select(@breakdowns.map{ |b| [b.name, b.id] }) %>')
