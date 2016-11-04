defIconFunction <-
  JS("function(icon){
        if(!$.isEmptyObject(icon)) {
          return L.icon(icon);
        } else {
          return L.icon();
        }
     }")

awesomeIconFunction <-
  JS("function(icon){
        if(!$.isEmptyObject(icon)) {
          if(!icon.prefix) {
            icon.prefix = icon.library;
          }
          return L.AwesomeMarkers.icon(icon);
        } else {
          return L.AwesomeMarkers.icon();
        }
     }")
