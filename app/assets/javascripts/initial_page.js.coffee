# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/




@setElementQuality = (uom, style_item, quality, from_value) ->
  if quality is "opacity"
    document.getElementById(style_item).style.opacity = from_value
    from_value
  else if quality is "height"
    document.getElementById(style_item).style.height = from_value.toString() + uom
    from_value
  else if quality is "margin-top"
    document.getElementById(style_item).style.marginTop = from_value.toString() + uom
    from_value
  else if quality is "top"
    document.getElementById(style_item).style.top = from_value.toString() + uom
    from_value
  else if quality is "left"
    document.getElementById(style_item).style.left = from_value.toString() + uom
    from_value
  else if quality is "width"
    document.getElementById(style_item).style.width = from_value.toString() + uom
    from_value


##


move_values = (uom, style_item, quality, from_value, to_value, step, tolerance) -> 
  if from_value < to_value
    from_value = from_value + step
  else if from_value > to_value
    from_value = from_value - step
  if to_value-from_value < tolerance and to_value-from_value > -1 * tolerance
    clearInterval update_values
  setElementQuality(uom, style_item, quality, from_value)

move_values_init = (uom, fps, style_item, quality, from_value, to_value, step, tolerance) -> 
  setInterval update_values = ->
    from_value = move_values(uom, style_item, quality, from_value, to_value, step, tolerance)
  , fps

value_to = (uom, time, fps, style_item, quality, from_value, to_value, step, tolerance = 0.001) ->
  setTimeout update_values = ->
    new_value = move_values_init(uom, fps, style_item, quality, from_value, to_value, step, tolerance)
  , time


##


detect_ellittic_speed = (speed_increase, from_value, focus_one, focus_two, rescaling) ->
  increase = focus_one + focus_two - 2*from_value
  speed_increase = speed_increase + increase/rescaling
  
move_ellittic = (direction, uom, style_item, quality, from_value, to_value, step, speed_increase) ->
  if direction is "up"
    if from_value < to_value
      speed = step
      step = step + speed*speed_increase
      from_value = from_value + step
      setElementQuality(uom, style_item, quality, from_value)

  else if direction is "down"
    if from_value > to_value
      speed = step
      step = step + speed*speed_increase
      from_value = from_value + step
      setElementQuality(uom, style_item, quality, from_value)


ellittic_motion = (direction, uom, fps, style_item, quality, from_value, to_value, step, speed_increase, focus_center, rescaling) ->
  distance = to_value - from_value
  focus_one = distance/focus_center
  focus_one = from_value + focus_one
  focus_two = distance/focus_center * (focus_center-1)
  focus_two = from_value + focus_two
  setInterval update_values = ->
    speed_increase = detect_ellittic_speed(speed_increase, from_value, focus_one, focus_two, rescaling)
    from_value = move_ellittic(direction, uom, style_item, quality, from_value, to_value, step, speed_increase)
  , fps

# rescaling tipically = 100. focus_center = 2~10
value_ellittic_to = (direction, uom, time, fps, style_item, quality, from_value, to_value, step, speed_increase, focus_center, rescaling) ->
  setTimeout update_values = ->
    new_value = ellittic_motion(direction, uom, fps, style_item, quality, from_value, to_value, step, speed_increase, focus_center, rescaling)
  , time


##


set_element_quality = (uom, time, style_item, quality, value) ->
  setTimeout update_values = ->
    new_value = setElementQuality(uom, style_item, quality, value)
  , time


##



##


@entering = ->
  #document.getElementById("logo_background").style.height = 95%;
  set_element_quality("%", 0, "logo_background", "height", 95);
  set_element_quality("%", 0, "logo_line", "top", 50);
  set_element_quality("px", 0, "logo_line", "margin-top", 39);
  set_element_quality("", 0, "logo_image", "opacity", 0); 
  set_element_quality("", 0, "logo_line", "opacity", 0); 
  set_element_quality("", 0, "header_tab", "opacity", 0);
  set_element_quality("", 0, "footer_menu", "opacity", 0);
  set_element_quality("", 0, "current_page", "opacity", 0);
  set_element_quality("", 0, "profile_image", "opacity", 0);

  value_to("", 500, 10, "logo_image", "opacity", 0, 0.6, 0.005);
  value_to("", 500, 10, "logo_line", "opacity", 0, 1, 0.01);
  value_to("", 1500, 10, "header_tab", "opacity", 0, 1, 0.005);
  value_ellittic_to("down", "%", 4000, 10, "logo_background", "height", 95, 10, 0.01, 0.001, 5, 80);
  value_ellittic_to("up", "%", 4000, 10, "logo_line", "top", 50, 100, 0.01, 0.001, 5, 80);
  value_ellittic_to("down", "px", 4000, 10, "logo_line", "margin-top", 39, -2, 0.03, 0.001, 20, 40);
  value_to("", 5000, 10, "footer_menu", "opacity", 0, 1, 0.01);
  value_to("", 5000, 10, "current_page", "opacity", 0, 1, 0.01);
  value_to("", 6000, 10, "profile_image", "opacity", 0, 0.9, 0.005);
