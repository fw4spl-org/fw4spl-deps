cmake_minimum_required(VERSION 3.0)

project(itkBuilder)

include(ExternalProject)

set(ITK_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                   -DBUILD_EXAMPLES:BOOL=OFF
                   -DBUILD_SHARED_LIBS:BOOL=ON
                   -DBUILD_TESTING:BOOL=OFF
                   -DBUILD_DOXYGEN:BOOL=OFF
                   -DITK_USE_REVIEW:BOOL=ON
                   
                   -DITK_USE_SYSTEM_DCMTK:BOOL=ON
                   -DITK_USE_SYSTEM_GDCM:BOOL=ON
                   -DITK_USE_SYSTEM_PNG:BOOL=ON
                   -DITK_USE_SYSTEM_TIFF:BOOL=ON
                   -DITK_USE_SYSTEM_VXL:BOOL=ON
                   -DITK_USE_SYSTEM_ZLIB:BOOL=ON
                   -DITK_USE_SYSTEM_JPEG:BOOL=ON
                   -DITK_USE_OPTIMIZED_REGISTRATION_METHODS:BOOL=ON
                   
                   -DITK_BUILD_DEFAULT_MODULES:BOOL=OFF
                   -DModule_ITKDeprecated:BOOL=OFF
                   -DModule_ITKMINC:BOOL=OFF
                   -DModule_ITKIOMINC:BOOL=OFF
                   -DModule_ITKV3Compatibility:BOOL=OFF
                   -DModule_ITKVideoBridgeOpenCV:BOOL=OFF
                   -DModule_ITKDCMTK:BOOL=OFF
                   -DModule_ITKIODCMTK:BOOL=OFF
                   

                   -DModule_ITKAnisotropicSmoothing:BOOL=ON
                   -DModule_ITKAntiAlias:BOOL=ON
                   -DModule_ITKBiasCorrection:BOOL=ON
                   -DModule_ITKBinaryMathematicalMorphology:BOOL=ON
                   -DModule_ITKBioCell:BOOL=ON
                   -DModule_ITKClassifiers:BOOL=ON
                   -DModule_ITKColormap:BOOL=ON
                   -DModule_ITKConnectedComponents:BOOL=ON
                   -DModule_ITKConvolution:BOOL=ON
                   -DModule_ITKCurvatureFlow:BOOL=ON
                   -DModule_ITKDeconvolution:BOOL=ON
                   -DModule_ITKDeformableMesh:BOOL=ON
                   -DModule_ITKDenoising:BOOL=ON
                   -DModule_ITKDiffusionTensorImage:BOOL=ON
                   -DModule_ITKDisplacementField:BOOL=ON
                   -DModule_ITKDistanceMap:BOOL=ON
                   -DModule_ITKEigen:BOOL=ON
                   -DModule_ITKFEM:BOOL=ON
                   -DModule_ITKFEMRegistration:BOOL=ON
                   -DModule_ITKFFT:BOOL=ON
                   -DModule_ITKFastMarching:BOOL=ON
                   -DModule_ITKGIFTI:BOOL=ON
                   -DModule_ITKGPUAnisotropicSmoothing:BOOL=ON
                   -DModule_ITKGPUImageFilterBase:BOOL=ON
                   -DModule_ITKGPUPDEDeformableRegistration:BOOL=ON
                   -DModule_ITKGPURegistrationCommon:BOOL=ON
                   -DModule_ITKGPUSmoothing:BOOL=ON
                   -DModule_ITKGPUThresholding:BOOL=ON
                   -DModule_ITKIOCSV:BOOL=ON
                   -DModule_ITKIOGE:BOOL=ON
                   -DModule_ITKIOIPL:BOOL=ON
                   -DModule_ITKIOMesh:BOOL=ON
                   -DModule_ITKIOPhilipsREC:BOOL=ON
                   -DModule_ITKIORAW:BOOL=ON
                   -DModule_ITKIOSiemens:BOOL=ON
                   -DModule_ITKIOSpatialObjects:BOOL=ON
                   -DModule_ITKIOTransformBase:BOOL=ON
                   -DModule_ITKIOTransformInsightLegacy:BOOL=ON
                   -DModule_ITKIOTransformMatlab:BOOL=ON
                   -DModule_ITKIOXML:BOOL=ON
                   -DModule_ITKImageCompare:BOOL=ON
                   -DModule_ITKImageCompose:BOOL=ON
                   -DModule_ITKImageFeature:BOOL=ON
                   -DModule_ITKImageFusion:BOOL=ON
                   -DModule_ITKImageGradient:BOOL=ON
                   -DModule_ITKImageGrid:BOOL=ON
                   -DModule_ITKImageIntensity:BOOL=ON
                   -DModule_ITKImageLabel:BOOL=ON
                   -DModule_ITKImageSources:BOOL=ON
                   -DModule_ITKImageStatistics:BOOL=ON
                   -DModule_ITKIntegratedTest:BOOL=ON
                   -DModule_ITKKLMRegionGrowing:BOOL=ON
                   -DModule_ITKLabelMap:BOOL=ON
                   -DModule_ITKLabelVoting:BOOL=ON
                   -DModule_ITKLevelSets:BOOL=ON
                   -DModule_ITKLevelSetsv4:BOOL=ON
                                     
                   -DModule_ITKMarkovRandomFieldsClassifiers:BOOL=ON
                   -DModule_ITKMathematicalMorphology:BOOL=ON
                   -DModule_ITKMetricsv4:BOOL=ON
                   -DModule_ITKNarrowBand:BOOL=ON
                   -DModule_ITKNeuralNetworks:BOOL=ON
                   -DModule_ITKOptimizers:BOOL=ON
                   -DModule_ITKOptimizersv4:BOOL=ON
                   -DModule_ITKPDEDeformableRegistration:BOOL=ON
                   -DModule_ITKPath:BOOL=ON
                   -DModule_ITKPolynomials:BOOL=ON
                   -DModule_ITKQuadEdgeMeshFiltering:BOOL=ON
                   -DModule_ITKRegionGrowing:BOOL=ON
                   -DModule_ITKRegistrationCommon:BOOL=ON
                   -DModule_ITKRegistrationMethodsv4:BOOL=ON
                   -DModule_ITKReview:BOOL=ON
                   -DModule_ITKSignedDistanceFunction:BOOL=ON
                   -DModule_ITKSmoothing:BOOL=ON
                   -DModule_ITKSpatialFunction:BOOL=ON
                   -DModule_ITKThresholding:BOOL=ON
                   
                   -DModule_ITKVideoCore:BOOL=ON
                   -DModule_ITKVideoFiltering:BOOL=ON
                   -DModule_ITKVideoIO:BOOL=ON
                   -DModule_ITKVoronoi:BOOL=ON
                   -DModule_ITKVTK:BOOL=ON
                   -DModule_ITKWatersheds:BOOL=ON
                   -DModule_ITKDICOMParser:BOOL=ON

                   # Disabled on Linux (link errors)
                   -DModule_ITKLevelSetsv4Visualization:BOOL=OFF
                   -DModule_ITKVtkGlue:BOOL=OFF
                   
                   # Disabled because Vxl vidl is not build anymore
                   -DModule_ITKVideoBridgeVXL:BOOL=OFF
)

set(CACHED_URL http://freefr.dl.sourceforge.net/project/itk/itk/4.6/InsightToolkit-4.6.1.tar.gz)
set(ITK_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

ExternalProject_Add(
    itk
    URL ${CACHED_URL}
    URL_HASH SHA256=ed42f94c0c0efce3cc5cbcce73052db4029ff54f33aad7340badcd589805c1b6
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${ITK_PATCH_DIR}/" "<SOURCE_DIR>/"
    DEPENDS zlib jpeg libpng tiff vxl gdcm vtk
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ITK_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(itk CopyConfigFileToInstall 
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-ITK.cmake ${CMAKE_INSTALL_PREFIX}/fw-ITK.cmake
    COMMENT "Install configuration file"
)
