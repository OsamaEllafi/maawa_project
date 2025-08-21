# Motion Tokens

## Duration Scale

### Micro Interactions (120-240ms)
- **Fast**: 120ms - Hover states, button presses
- **Base**: 150ms - Standard micro interactions
- **Slow**: 200ms - Complex state changes
- **Slower**: 240ms - Multi-step micro interactions

### Page Transitions (250-400ms)
- **Fast**: 250ms - Quick page changes
- **Base**: 300ms - Standard page transitions
- **Slow**: 350ms - Complex page transitions
- **Slower**: 400ms - Full screen transitions

### Special Animations
- **Instant**: 0ms - Immediate changes
- **Quick**: 100ms - Very fast feedback
- **Extended**: 500ms - Loading states, reveals
- **Long**: 1000ms - Onboarding, tutorials

## Easing Curves

### Standard Easings
- **Linear**: `Curves.linear` - Constant speed, mechanical
- **Ease**: `Curves.ease` - Standard web easing
- **Ease In**: `Curves.easeIn` - Slow start, fast end
- **Ease Out**: `Curves.easeOut` - Fast start, slow end
- **Ease In Out**: `Curves.easeInOut` - Slow start and end

### Emphasized Easings
- **Ease In Cubic**: `Curves.easeInCubic` - Strong acceleration
- **Ease Out Cubic**: `Curves.easeOutCubic` - Strong deceleration
- **Ease In Out Cubic**: `Curves.easeInOutCubic` - Strong both ends

### Custom Easings
- **Bounce**: `Curves.bounceOut` - Playful bounce effect
- **Elastic**: `Curves.elasticOut` - Spring-like motion
- **Back**: `Curves.easeOutBack` - Slight overshoot

## Animation Types

### Transform Animations
- **Scale**: Grow/shrink effects
- **Translate**: Movement animations
- **Rotate**: Rotation effects
- **Skew**: Perspective changes

### Opacity Animations
- **Fade In**: 0 → 1 opacity
- **Fade Out**: 1 → 0 opacity
- **Cross Fade**: Simultaneous fade in/out

### Layout Animations
- **Slide**: Horizontal/vertical movement
- **Expand**: Height/width changes
- **Flip**: 3D rotation effects

## Usage Guidelines

### Micro Interactions
- Use **Fast (120ms)** for immediate feedback
- Use **Base (150ms)** for standard hover/press states
- Use **Slow (200ms)** for complex state changes
- Apply **easeOut** for most micro interactions

### Page Transitions
- Use **Base (300ms)** for standard navigation
- Use **Fast (250ms)** for quick back/forward
- Use **Slow (350ms)** for complex layouts
- Apply **easeInOut** for page transitions

### Loading States
- Use **Extended (500ms)** for skeleton loading
- Use **Long (1000ms)** for progress indicators
- Apply **linear** for progress bars
- Apply **ease** for skeleton shimmer
