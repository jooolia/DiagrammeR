context("Create a color palette with specified parameters")

test_that("a color palette can be generated", {

  # Create a palette of 12 colors
  colors_12 <- roll_palette(number = 12,
                            hue_range = c(0, 360),
                            chroma_range = c(0, 3),
                            lightness_range = c(0.75, 1.5),
                            alpha = NULL,
                            display_colors = TRUE)

  # Expect that a vector object of "character" class is generated
  expect_is(colors_12, "character")

  # Expect that 12 colors are generated
  expect_true(length(colors_12) == 12L)

  # Expect that all colors are unique
  expect_true(length(unique(colors_12)) == 12L)

  # Expect that the hexadecimal color values are well-formed
  expect_match(colors_12, "^#[A-F0-9]{6}$")
})