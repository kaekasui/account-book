$("select#record_breakdown_id").children().remove()
$("select#record_breakdown_id").html("<%= j options_for_select(@breakdowns.map{ |b| [b.name, b.id] }.insert(0, ["#{I18n.t('include_blank.breakdown')}", ''])) %>")
