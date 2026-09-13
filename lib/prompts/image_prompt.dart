class ImagePrompt {
  static String build({
    required String manufacturer,
    required String bike,
    required String year,
    required String style,
  }) {
    return """
Create a highly realistic custom motorcycle concept image.

BASE MOTORCYCLE

Manufacturer:
$manufacturer

Model:
$bike

Year:
$year

TARGET CUSTOM STYLE:
$style


MAIN OBJECTIVE

Create a realistic vision of what this motorcycle could look like
after being customized toward the user's selected style.

The motorcycle must remain clearly recognizable as the original
motorcycle model.

Do not transform it into a completely different motorcycle.


STYLE PRIORITY

The entire motorcycle should be designed around:

$style

Express the style through:

- overall silhouette
- proportions
- stance
- handlebar
- fuel tank
- seat
- front end
- rear section
- exhaust
- wheels
- tires
- lighting
- riding position
- visual balance


REALISTIC CUSTOMIZATION

The motorcycle should look like a real custom motorcycle
that could realistically exist in the real world.

Avoid:

- futuristic designs
- sci-fi elements
- fantasy motorcycle designs
- impossible mechanical structures
- floating parts
- unrealistic proportions
- exaggerated body shapes


IMPORTANT

Keep the original motorcycle identity recognizable.

Respect:

- engine layout
- frame characteristics
- wheel proportions
- motorcycle size
- general mechanical architecture


STYLE CONSISTENCY

Do not mix unrelated motorcycle styles.

Always prioritize:

$style


VISUAL PRESENTATION

Show the entire motorcycle.

Use a clean three-quarter front-side view.

Professional custom motorcycle photography.

Dark minimal background.

Premium custom motorcycle aesthetic.

Realistic metal materials.

Realistic paint.

Realistic tires.

Realistic lighting.

High detail.

Sharp motorcycle silhouette.

No people.

No text.

No logos.

No watermark.

The final image should look like a professional
custom motorcycle photograph rather than a digital illustration.
""";
  }
}