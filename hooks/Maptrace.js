import mapboxgl from "mapbox-gl";

const MapTrace = {
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
    while (this.el.firstChild) {
      this.el.removeChild(this.el.firstChild);
    }

    const map = this.initMap();
    let currentMarker = null;

    map.on("click", (e) => {
      const [longitude, latitude] = e.lngLat.toArray();

      if (currentMarker) {
        currentMarker.remove();
      }

      currentMarker = new mapboxgl.Marker()
        .setLngLat([longitude, latitude])
        .addTo(map);

      // Sends the clicked coordinates back to the LiveView
      this.pushEvent("map-click", { lat: latitude, long: longitude });
    });
  },
};
export { MapTrace };
