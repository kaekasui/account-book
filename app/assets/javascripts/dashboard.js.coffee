$(document).on('ready page:load', (e) ->
  if $(".container").hasClass("dashboards_show")
    $.ajax({
      url: "dashboard/set_graph",
      type: "POST",
      beforeSend: (xhr) -> xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')),
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      success: (response) ->
      error: (response) -> alert("グラフデータ取得に失敗しました")
    })

  ###
  margin = { top: 20, right: 20, bottom: 30, left: 50 }
  width = 500
  height = 200

  svg = d3.select(".dashboards_show").select(".panel-body")
    .append("svg")
    .attr({width: width, height:200})

  ---
  svg.selectAll(".bar")
    .data(data)
    .enter().append("rect").attr({class: 'bar'})

  dataset = [11, 45, 20, 33]
  w=500
  h=200
  r = (d) ->
    d

  main = d3.select(".dashboards_show").select(".main")
  svg = main.append("svg").attr({width:500, height:200})
  svg.selectAll("circle")
    .data(dataset)
    .enter()
    .append("circle")
    .attr({
      cx: cx = (d, i) -> 50 + (i * 100)
      cy: h/2
      r: 0
      fill: "red"
    })
    .transition()
    .duration(1000)
    .ease("bounce")
    .attr({
      r: r = (d) -> d
    })
   ###
)
