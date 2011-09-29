/*
  Oursignal

  Treemap
    Most of squarify(), worst() and position() nicked from the d3 library.
    http://mbostock.github.com/d3/
*/
var oursignal = (function ($, oursignal) {
  var $timestep,
      links,
      links_length,
      round = Math.round,
      ratio = 0.5 * (1 + Math.sqrt(5)); // Golden ratio.

  function squarify() {
    var rect     = {x: links.x, y: links.y, dx: links.dx, dy: links.dy},
        row      = [],
        children = links.slice(), // Copy.
        child,
        best     = Infinity,
        score,
        u        = Math.min(rect.dx, rect.dy),
        n;

    row.area = 0;
    while ((n = children.length) > 0) {
      row.push(child = children[n - 1]);
      row.area += child.area;
      if ((score = worst(row, u)) <= best) {
        children.pop();
        best = score;
      }
      else {
        row.area   -= row.pop().area;
        position(row, u, rect, false);
        u          = Math.min(rect.dx, rect.dy);
        row.length = row.area = 0;
        best       = Infinity;
      }
    }
    if (row.length) {
      position(row, u, rect, true);
      row.length = row.area = 0;
    }
  }

  function worst(row, u) {
    var s    = row.area,
        r,
        rmax = 0,
        rmin = Infinity,
        i    = -1,
        n    = row.length;

    while (++i < n) {
      if (!(r = row[i].area)) continue;
      if (r < rmin) rmin = r;
      if (r > rmax) rmax = r;
    }
    s *= s;
    u *= u;
    return s
        ? Math.max((u * rmax * ratio) / s, s / (u * rmin * ratio))
        : Infinity;
  }

  function position(row, u, rect, flush) {
    var i = -1,
        n = row.length,
        x = rect.x,
        y = rect.y,
        v = u ? round(row.area / u) : 0,
        o;
    if (u == rect.dx) { // horizontal subdivision
      if (flush || v > rect.dy) v = v ? rect.dy : 0; // over+underflow
      while (++i < n) {
        o = row[i];
        o.x = x;
        o.y = y;
        o.dy = v;
        x += o.dx = v ? round(o.area / v) : 0;
      }
      o.z = true;
      o.dx += rect.x + rect.dx - x; // rounding error
      rect.y += v;
      rect.dy -= v;
    } else { // vertical subdivision
      if (flush || v > rect.dx) v = v ? rect.dx : 0; // over+underflow
      while (++i < n) {
        o = row[i];
        o.x = x;
        o.y = y;
        o.dx = v;
        y += o.dy = v ? round(o.area / v) : 0;
      }
      o.z = false;
      o.dy += rect.y + rect.dy - y; // rounding error
      rect.x += v;
      rect.dx -= v;
    }
  }

  // TODO: Animation. Do it intersection style so existing ID's remain and morph?
  function layout() {
    var link, $link;
    $timestep.children().remove();
    console.warn(links);
    for (var i = 0; i < links_length; i++) {
      link  = links[i];
      $link = $('<li/>', {'data-link_id': link.id, 'data-link_score': link.score})
        .css({left: link.x, top: link.y, width: link.dx, height: link.dy})
        .append($('<a/>', {href: link.url, text: link.title}));
      $timestep.append($link);
    }
  }

  function scale() {
    var child,
        area,
        timestep_offset = $timestep.offset();

    // Root.
    links.x  = timestep_offset.left;
    links.y  = timestep_offset.top;
    links.dx = $timestep.width();
    links.dy = $timestep.height();

    // Children.
    for (var i = 0; i < links_length; i++) {
      area = (child = links[i].score * (links.dx * links.dy / links.score));
      links[i].area = isNaN(area) || area <= 0 ? 0 : area;
    }
  }

  function treemap(data) {
    links        = data;
    links_length = data.length;
    links.score  = 0;

    for (var i = 0; i < links_length; i++) links.score += links[i].score;

    $(document).resize(function() {
      scale();
      squarify();
      layout();
    }).resize();
  }

  oursignal.timestep = function(time) {
    $.getJSON('/timestep.json', {time: time}, function(links) {
      $(function() {
        if (!$timestep) $timestep = $('#timestep');
        treemap(links);
      });
    });
  };

  return oursignal;
})(jQuery, oursignal || {});

// Current.
oursignal.timestep();
