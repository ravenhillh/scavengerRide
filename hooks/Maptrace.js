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

  clearMarkers() {
    this.markers.forEach((marker) => marker.remove());
    this.markers = [];
  },

  mounted() {
    while (this.el.firstChild) {
      this.el.removeChild(this.el.firstChild);
    }

    const map = this.initMap();
    let currentMarker = null;

    const nav = new mapboxgl.NavigationControl();
    map.addControl(nav, "top-right");
    this.markers = [];

    this.handleEvent("button_clicked_js", (res) => {
      if (currentMarker) {
        currentMarker.remove();
      }
      this.clearMarkers();
      res.payload.map((marker) => {
        const markerContent = `<div>
        <h3>${marker.name}</h3>
        <div>${marker.prompt}</div>
        </div>`;

        const popUp = new mapboxgl.Popup({ offset: 25 }).setHTML(markerContent);

        const marker1 = new mapboxgl.Marker({
          color: "black",
          draggable: false,
        })
          .setLngLat([marker.long, marker.lat])
          .setPopup(popUp)
          .addTo(map);

        marker1
          .getElement()
          .addEventListener("mouseenter", () => marker1.togglePopup());
        marker1
          .getElement()
          .addEventListener("mouseleave", () => marker1.togglePopup());
        // Handle the message received from the server
        this.markers.push(marker1);
      });
    });

    map.on("click", (e) => {
      const [longitude, latitude] = e.lngLat.toArray();
      const lat = Number(latitude.toFixed(2));
      const long = Number(longitude.toFixed(2));
      if (currentMarker) {
        currentMarker.remove();
      }

      currentMarker = new mapboxgl.Marker()
        .setLngLat([longitude, latitude])
        .addTo(map);

      // Sends the clicked coordinates back to the LiveView
      this.pushEvent("map-click", { lat: lat, long: long });
    });
  },
};
export { MapTrace };
