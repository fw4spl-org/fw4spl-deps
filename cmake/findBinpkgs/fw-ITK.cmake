set(ITK_DIR ${CMAKE_CURRENT_LIST_DIR}/lib/)

set(ITK_LIBS ITKAlgorithms
    ITKBiasCorrection
    ITKBioCell
    ITKCommon
    ITKDICOMParser
    ITKEXPAT
    ITKFEM
    itkdouble-conversion
    ITKGDCM
    ITKgiftiio
    ITKIOBioRad
    ITKIOBMP
    ITKIOCSV
    ITKIOGDCM
    ITKIOGE
    ITKIOGIPL
    ITKIOHDF5
    ITKIOImageBase
    ITKIOIPL
    ITKIOJPEG
    itksys
    ITKVNLInstantiation
    itkNetlibSlatec
    ITKStatistics
    ITKMesh
    ITKMetaIO
    ITKSpatialObjects
    ITKPath
    ITKLabelMap
    ITKQuadEdgeMesh
    ITKOptimizers
    ITKPolynomials
    ITKIOXML
    ITKIOSpatialObjects
    ITKznz
    ITKniftiio
    ITKIOMesh
    ITKIOMeta
    ITKIONIFTI
    ITKNrrdIO
    ITKIONRRD
    ITKIOPNG
    ITKIOPhilipsREC
    ITKIOSiemens
    ITKIOStimulate
    ITKIOTIFF
    ITKIOTransformBase
    ITKIOTransformHDF5
    ITKIOTransformInsightLegacy
    ITKIOTransformMatlab
    ITKIOVTK
    ITKIOLSM
    ITKKLMRegionGrowing
    ITKOptimizersv4
    itkopenjpeg
    ITKVTK
    ITKWatersheds
    ITKReview
    itkTestDriver
    ITKVideoCore
    ITKVideoIO
    )


foreach(LIB ${ITK_LIBS})
    find_library(${LIB}_LIB ${LIB}-4.5 ${ITK_DIR} )
    add_library(${LIB} UNKNOWN IMPORTED)
    set_target_properties(${LIB} PROPERTIES IMPORTED_LOCATION "${${LIB}_LIB}")
    set(ITK_LIBRARIES ${ITK_LIBRARIES} ${${LIB}_LIB})
endforeach()
