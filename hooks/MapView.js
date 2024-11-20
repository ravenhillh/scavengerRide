import mapboxgl from "mapbox-gl";

const MapView = {
  /**
   * Initializes the map with the given configuration and displays it on the specified container.
   *
   * @return {mapboxgl.Map} The map object.
   */
  initMap() {
    mapboxgl.accessToken =
      "pk.eyJ1IjoicmF2ZW4taHVnaGVzIiwiYSI6ImNtMzNrdXFrZjAxN3cybHB6Mzh4cGQweWYifQ.qFcsFpM3F9QTafM6HhKkwg";

    const mapConfig = {
      container: "map",
      style: "mapbox://styles/mapbox/streets-v12",
      center: [-90, 30],
      zoom: 11,
    };

    const map = new mapboxgl.Map(mapConfig);

    return map;
  },

  mounted() {
    const map = this.initMap();

    this.handleEvent("update_map_data", ({ locations }) => {
      //   Remove existing markers if any
      const existingMarkers =
        document.getElementsByClassName("mapboxgl-marker");
      while (existingMarkers[0]) {
        existingMarkers[0].remove();
      }

      // Add new markers for each location
      locations.forEach((location) => {
        const { lat, long, name } = location;

        // Create marker element
        const marker = new mapboxgl.Marker()
          .setLngLat([long, lat])
          .setPopup(new mapboxgl.Popup().setHTML(`<h3>${name}</h3>`))
          .addTo(map);
      });

      // Fit map bounds to show all markers
      if (locations.length > 0) {
        const bounds = new mapboxgl.LngLatBounds();
        locations.forEach((location) => {
          bounds.extend([location.long, location.lat]);
        });
        map.fitBounds(bounds, { padding: 50 });
      }
    });
  },
};
export { MapView };
