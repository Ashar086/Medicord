import 'package:brainmri/screens/observation/brain/brain_observation_model.dart';

String fillObservationTemplate(BrainObservationModel observation) {
  return """
  Here is the information from the observations to update the template:
  - Scanning Technique: ${observation.scanningTechnique}
  - Basal Ganglia: (Heading)
    - Location: ${observation.basalGangliaLocation}
    - Symmetry: ${observation.basalGangliaSymmetry}
    - Contour: ${observation.basalGangliaContour}
    - Dimensions: ${observation.basalGangliaDimensions}
    - MR Signal: ${observation.basalGangliaSignal}
  - Brain Grooves and Ventricles: (Heading)
    - Lateral Ventricles Width: Right: ${observation.lateralVentriclesWidthRight} mm, Left: ${observation.lateralVentriclesWidthLeft} mm
    - Third Ventricle Width: ${observation.thirdVentricleWidth} mm
    - Sylvian Aqueduct: ${observation.sylvianAqueductCondition}
    - Fourth Ventricle: ${observation.fourthVentricleCondition}
  - Brain Structures: (Heading)
    - Corpus Callosum: ${observation.corpusCallosumCondition}
    - Brain Stem: ${observation.brainStemCondition}
    - Cerebellum: ${observation.cerebellumCondition}
    - Craniovertebral Junction: ${observation.craniovertebralJunctionCondition}
    - Pituitary Gland: Normal shape, height ${observation.pituitaryGlandCondition} mm in sagittal projection
  - Optic Nerves and Orbital Structures: (Heading)
    - Orbital Cones Shape: ${observation.orbitalConesShape}
    - Eyeballs Shape and Size: ${observation.eyeballsShapeSize}
    - Optic Nerves Diameter: ${observation.opticNervesDiameter}
    - Extraocular Muscles: ${observation.extraocularMusclesCondition}
    - Retrobulbar Fatty Tissue: ${observation.retrobulbarFattyTissueCondition}
  - Paranasal Sinuses: (Heading)
    - Cysts Presence: ${observation.sinusesCystsPresence ? 'Yes' : 'No'}
    - Cysts Size: ${observation.sinusesCystsSize} mm
    - Sinuses Pneumatization: ${observation.sinusesPneumatization}
  - Additional Observations: ${observation.additionalObservations}
  """;
}