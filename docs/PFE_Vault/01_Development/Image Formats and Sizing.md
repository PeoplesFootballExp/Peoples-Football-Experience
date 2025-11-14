
In order to optimize for Godot, there should be some standards to ensure image processing is optimized for memory space and loading speeds.

## Memory Space Optimizations

Saving memory space for images will be very important, as there will be many territories, many teams, and many kits in the game. At the very minimum, there will likely need to be 5,000 + images to use for logos and this is not accounting for UI elements, backgrounds, 3 kits per team, and all the textures for 3D models. Suffice to say, there will be many images/textures in the game. In order to avoid bloating the memory too much, we must find ways to minimize storage space for the textures.

### Method 1: Reusing Images

When possible, reuse images. For instance, if there is a national team that has a logo, then that logo can be reused for all its youth teams. So the logo for England National Team can be reused for England U23. England U20, and England U17 teams. In this example, we reduce the images for 4 teams to a single image that all teams can use. While logos or textures is a good place for this, this also applies to other things such as UI elements and even backgrounds. 

### Method 2: Saving in WebP Format

Different Image Formats take up different amounts of space on average due to the compressional ability of the format. PNG work great for logos and textures, because they support alpha transparency (which JPEG can't). From the supported files (excluding SVG), WebP serves the best purpose for both measures needed. It is slightly faster at decoding in Godot (compared to PNG), supports transparency (needed for logos), and takes up less memory space on average compared to PNG. For these reasons, images saved should be used as much as possible over PNG to possibly save about 25 to 40% of memory storage. 

### Method 3: Saving in JPEG XL

JPEG XL is a new image format, like AVIF, is attempting to be the image format of the future. JPEG XL would result in smaller image sizes for photos compared to WebP and PNG (slightly losing to AVIF). Even if AVIF has the absolute smallest compression sizes, JPEG XL has much more features, future proof, and is more designed for archival systems. Both AVIF and JPEG XL are not supported by Godot, but they would be the best option to export the game with. Since Godot pulls images from user:// folder and not res:// folder (and especially since we want to allow users to input their own images) we can save images in res:// as JPEG XL and then converted to WebP when saving in user:// folder. This allows us to further reduce our memory storage while ensuring this format stays secure for the future.

## Loading Times

Loading times is important for a UI heavy game where textures can be loaded dynamically. The biggest reason for stuttering in the game so far is the I/O loading of images. Since these are read from disk, this tends to be on the slower side. While Godot has some good optimizations for images, and we can implement some code optimizations such as caching, we still want the loading time of images to be as fast as possible

### Method 1: Use WebP Format

Regardless of the image format in the res:// folder, the user:// image format must be in WebP as it has the fastest load times in Godot. Being designed for websites, WebP is built in fast decoding and encoding time in mind. This means, images will be loaded just slightly faster than PNGs. 

## Conclusion

To save memory space and speed up image loading times, we shall use WebP images in the user:// folder. For the res:// folder, we can either use WebP or ideally JPEG XL images. 


Convert PNG to JPEG XL
Get-ChildItem -Path $input_dir -Filter "*.png" | ForEach-Object {
    $baseName = $_.BaseName
    .\cjxl.exe -q 85 -e 10 "$($_.FullName)" "$output_dir$baseName.jxl"
}