{...}: {
  programs.yazi = {
    enable = true;
    settings = {
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };
  };
}
