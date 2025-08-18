{ pkgs, ... }:

{
  packages = with pkgs; [
    nixfmt-rfc-style
    git
    biome
    awscli2
  ];

  dotenv.enable = true;
  languages.javascript = {
    enable = true;
    bun.enable = true;
  };

  scripts.update-static-assets.exec = ''
    set +x
    GIT_ROOT=$(git rev-parse --show-toplevel)
    if [ ! -e ./static-assets ]; then
      echo "Incorrect directory; must have static-assets folder."
      exit 1
    fi
    ${pkgs.awscli2}/bin/aws s3 sync --exclude '.*' \
     --profile ian --acl public-read \
      $GIT_ROOT/static-assets s3://static.ian.pw/images/
  '';
}
