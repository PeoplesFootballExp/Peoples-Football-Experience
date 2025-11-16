
In order to optimize for Godot, there should be some standards to ensure image processing is optimized for memory space and loading speeds.
DISCLAIMER: It is important not to pre-optimize too much. Sometimes, the simpler solution is faster than a supposed optimized solution. The methods below are useful once we identify an issue with memory space or loading times.
## Memory Space Optimizations

Saving memory space for images will be very important, as there will be many territories, many teams, and many kits in the game. At the very minimum, there will likely need to be 5,000 + images to use for logos and this is not accounting for UI elements, backgrounds, 3 kits per team, and all the textures for 3D models. Suffice to say, there will be many images/textures in the game. In order to avoid bloating the memory too much, we must find ways to minimize storage space for the textures.

### Method 1: Reusing Images

When possible, reuse images. For instance, if there is a national team that has a logo, then that logo can be reused for all its youth teams. So the logo for England National Team can be reused for England U23. England U20, and England U17 teams. In this example, we reduce the images for 4 teams to a single image that all teams can use. While logos or textures is a good place for this, this also applies to other things such as UI elements and even backgrounds. 

### Method 2: Saving in WebP Format

Different Image Formats take up different amounts of space on average due to the compressional ability of the format. PNG work great for logos and textures, because they support alpha transparency (which JPEG can't). From the supported files (excluding SVG), WebP serves the best purpose for both measures needed. It is slightly faster at decoding in Godot (compared to PNG), supports transparency (needed for logos), and takes up less memory space on average compared to PNG. For these reasons, images saved should be used as much as possible over PNG to possibly save about 25 to 40% of memory storage. 

### Method 3: Saving in JPEG XL

JPEG XL is a new image format, like AVIF, is attempting to be the image format of the future. JPEG XL would result in smaller image sizes for photos compared to WebP and PNG (slightly losing to AVIF). Even if AVIF has the absolute smallest compression sizes, JPEG XL has much more features, future proof, and is more designed for archival systems. Both AVIF and JPEG XL are not supported by Godot, but they would be the best option to export the game with. Since Godot pulls images from user:// folder and not res:// folder (and especially since we want to allow users to input their own images) we can save images in res:// as JPEG XL and then converted to WebP when saving in user:// folder. This allows us to further reduce our memory storage while ensuring this format stays secure for the future.

### Method 4: Principle of minimum sizes: Dimension and Quality

We can further decrease memory size by reducing the overall dimensions of the images saved. For this, we can use something as the principle of minimum sizes where we ask ourselves how much space on screen something will take up. For example, for a simple UI arrow that will take up around 50 pixels on screen, it seems excessive to save a 2048 x 2048 image of this UI element in memory. The smaller the image will be in game (or even how important the texture will be to the game), the smaller or less detailed the image can be. This can be achieved by resizing the images to the minimum size and use lossy compression before it gets too blurry. Also, most devices and GPU are highly optimized for images in POT (Power of Two) dimensions, so we should try to stick to that as much as possible. Although, other non standard POT dimensions likely won't cause too much trouble

## Loading Times Optimizations

Loading times is important for a UI heavy game where textures can be loaded dynamically. The biggest reason for stuttering in the game so far is the I/O loading of images. Since these are read from disk, this tends to be on the slower side. While Godot has some good optimizations for images, and we can implement some code optimizations such as caching, we still want the loading time of images to be as fast as possible

### Method 1: Use WebP Format

Regardless of the image format in the res:// folder, the user:// image format must be in WebP as it has the fastest load times in Godot. Being designed for websites, WebP is built in fast decoding and encoding time in mind. This means, images will be loaded just slightly faster than PNGs. 

### Method 2: Local Caching

Although Godot does a good job of caching images into ready to use formats in .godot/.imported/ folder, this still means reading from disk. Disk reads are typically pretty slow, even if the access and optimizations from Godot make this quicker. To reduce loading times even more, we can cache images locally in code to further reduce time spent accessing images. Caching Images result in much faster access from VRAM, which can speed up times by a lot. It is important to not cache too much, but for items that will always need to accessed in a scene, we can load and cache the images at the start of the scene, reducing all future reads significantly. For now, the Asset Manager will have a permeant cache (used for all images we KNOW we will use) and a sort of FIFO cache (used for more dynamic image access). Whenever the image is not in the local cache, it will resort to normal Godot image access which is reasonably fast already.

### Method 3: Texture Atlas

For more static textures like UI elements or Territory Flags, we can merge all of them into a massive texture that Godot can then index to get the image we like. Similar to a sprite sheet, this can help speed up image loading by reducing the number of draw calls needed. Since the images will also be loaded continuously in VRAM, it also helps with cache access as continuous memory is more cache friendly than random memory access. In general, this won't help with memory space but it can depending on how densely packed the image is (like reducing the number of alpha space in the image overall). This does however, help quite a bit with loading times as it helps with caching locality and reducing the number of draw calls that Godot has to do.

### Method 4: Texture Arrays

Texture Arrays are great for textures that are all the same size and image format. This reduces the number of GPU draw calls the most and is most shader friendly. Plus, this method avoids texture bleeding entirely, reliably reducing and speeding up the GPU drawing times by reducing number of draw calls for images, less overhead than texture atlas, and does not introduce texture bleeding. Mainly used for 3D, but can be used by 2D images when the requirements are meant mentioned in the first sentence. If those requirements are met, then texture arrays are a simple way to speed up the images loading from the GPU. 

### Method 4: Asynchronous or Multithreaded Loading

While we may not be able to reduce the loading time of an individual image lower, we can decrease the amount of time the game is stalled by the image loading. For one, we can asynchronously access the image, reducing the stuttering that many games see from image accessing. This is perfect for single core devices, as we can use the single core multiple threads to reduce stuttering. For multi core devices, we can achieve even faster load times by loading in the images in parallel, reducing the total time spent loading all the images even if we can't reduce the single image loading time down any further. Even for mobile, most smartphones these days have around the range of 6-10 cores, with some older phones have as little as 1 or 4 cores.

## Image Dimensions


| Type of File     | Ideal Width | Ideal Height | Color Depth | Format res:// | Format user:// |
| ---------------- | ----------- | ------------ | ----------- | ------------- | -------------- |
| Any Type of Logo | 256         | 256          | 32          | jxl           | webp           |
| Territory Flag   | 256         | 384          | 32          | jxl           | webp           |



## Conclusion

In order to reduce the file size of the final game as well as ensuring it runs fast on many devices, these optimizations will be used to ensure the player gets the best experience when playing the game.


Convert PNG to JPEG XL
Get-ChildItem -Path $input_dir -Filter "*.png" | ForEach-Object {
    $baseName = $_.BaseName
    .\cjxl.exe -q 85 -e 10 "$($_.FullName)" "$output_dir$baseName.jxl"
}