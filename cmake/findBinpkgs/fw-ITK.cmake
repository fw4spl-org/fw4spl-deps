set(ITK_DIR ${CMAKE_CURRENT_LIST_DIR}/lib/InsightToolkit/)

SET(ITK_LIBS ITKAlgorithms
    ITKBasicFilters
    ITKCommon
    ITKDICOMParser
    ITKEXPAT
    ITKFEM
    ITKIO
    ITKIOReview
    ITKMetaIO
    ITKNrrdIO
    ITKNumerics
    ITKQuadEdgeMesh
    ITKSpatialObject
    ITKStatistics
    ITKniftiio
    ITKznz
    itkNetlibSlatec
    itkjpeg12
    itkjpeg16
    itkjpeg8
    itkopenjpeg
    itksys
    itkvnl_inst
    )


foreach(LIB ${ITK_LIBS})
    find_library(${LIB}_LIB ${LIB} ${ITK_DIR} )
    add_library(${LIB} UNKNOWN IMPORTED)
    set_target_properties(${LIB} PROPERTIES IMPORTED_LOCATION "${${LIB}_LIB}")
    set(ITK_LIBRARIES ${ITK_LIBRARIES} ${${LIB}_LIB})
endforeach()
