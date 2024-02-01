function ans = readimage(url)

# download image
[fid, name, msg] = mkstemp ("/tmp/urlXXXXXX");
cmd = ["wget -q -N -O ", name, " ", url];
status = system(cmd);
if (status != 0)
  error "Error downloading image.";
endif

# image size  in dim{1} dim{2}
cmd = ["identify -ping -format '%w,%h' ", name];
[status, dim] = system(cmd);
if (status != 0)
  error "Error reading image.";
endif
dim = textscan(dim, "%d,%d");

# convert image to grayscale binary
name2 = [name, ".gray"];
cmd = ["convert -define quantum:format=floating-point -depth 64 ", name, " ", name2];
status = system(cmd);
if (status != 0)
  error "Error converting image.";
endif

# read converted image
f = fopen(name2, "rb");
x = fread(f, "double");
fclose(f);
cmd = ["rm -f ", name, "*"];
system(cmd);

ans = reshape(x, [dim{1}, dim{2}])';

endfunction
