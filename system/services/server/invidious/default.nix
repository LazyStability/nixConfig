_: {
  services.invidious = {
    enable = false;
    nginx.enable = false;
    port = 12345;

    # if you want to disable recommended videos
    settings = {
      default_user_preferences = {
        "related_videos" = false;
      };
    };
  };
}
