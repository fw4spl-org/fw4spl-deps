cmake_minimum_required(VERSION 2.8)

PROJECT(icule)

INCLUDE_DIRECTORIES(
    ../common
  )

SET (ICULE_SOURCE_FILES
    AlternateSubstSubtables.cpp
    AnchorTables.cpp
    ArabicLayoutEngine.cpp
    ArabicShaping.cpp
    CanonData.cpp
    CanonShaping.cpp
    ClassDefinitionTables.cpp
    ContextualGlyphInsertionProc2.cpp
    ContextualGlyphSubstProc.cpp
    ContextualGlyphSubstProc2.cpp
    ContextualSubstSubtables.cpp
    CoverageTables.cpp
    CursiveAttachmentSubtables.cpp
    DeviceTables.cpp
    ExtensionSubtables.cpp
    Features.cpp
    GDEFMarkFilter.cpp
    GlyphDefinitionTables.cpp
    GlyphIterator.cpp
    GlyphLookupTables.cpp
    GlyphPositionAdjustments.cpp
    GlyphPositioningTables.cpp
    GlyphPosnLookupProc.cpp
    GlyphSubstitutionTables.cpp
    GlyphSubstLookupProc.cpp
    GXLayoutEngine.cpp
    GXLayoutEngine2.cpp
    HangulLayoutEngine.cpp
    HanLayoutEngine.cpp
    IndicClassTables.cpp
    IndicLayoutEngine.cpp
    IndicRearrangementProcessor.cpp
    IndicRearrangementProcessor2.cpp
    IndicReordering.cpp
    KernTable.cpp
    KhmerLayoutEngine.cpp
    KhmerReordering.cpp
    LayoutEngine.cpp
    LEFontInstance.cpp
    LEGlyphStorage.cpp
    LEInsertionList.cpp
    LigatureSubstProc.cpp
    LigatureSubstProc2.cpp
    LigatureSubstSubtables.cpp
    loengine.cpp
    LookupProcessor.cpp
    Lookups.cpp
    LookupTables.cpp
    MarkArrays.cpp
    MarkToBasePosnSubtables.cpp
    MarkToLigaturePosnSubtables.cpp
    MarkToMarkPosnSubtables.cpp
    MirroredCharData.cpp
    MorphTables.cpp
    MorphTables2.cpp
    MPreFixups.cpp
    MultipleSubstSubtables.cpp
    NonContextualGlyphSubstProc.cpp
    NonContextualGlyphSubstProc2.cpp
    OpenTypeLayoutEngine.cpp
    OpenTypeUtilities.cpp
    PairPositioningSubtables.cpp
    ScriptAndLanguage.cpp
    ScriptAndLanguageTags.cpp
    SegmentArrayProcessor.cpp
    SegmentArrayProcessor2.cpp
    SegmentSingleProcessor.cpp
    SegmentSingleProcessor2.cpp
    ShapingTypeData.cpp
    SimpleArrayProcessor.cpp
    SimpleArrayProcessor2.cpp
    SinglePositioningSubtables.cpp
    SingleSubstitutionSubtables.cpp
    SingleTableProcessor.cpp
    SingleTableProcessor2.cpp
    StateTableProcessor.cpp
    StateTableProcessor2.cpp
    SubstitutionLookups.cpp
    SubtableProcessor.cpp
    SubtableProcessor2.cpp
    ThaiLayoutEngine.cpp
    ThaiShaping.cpp
    ThaiStateTables.cpp
    TibetanLayoutEngine.cpp
    TibetanReordering.cpp
    TrimmedArrayProcessor.cpp
    TrimmedArrayProcessor2.cpp
    ValueRecords.cpp
)

SET(ICULE_HEADER_FILES
    AlternateSubstSubtables.h
    AnchorTables.h
    ArabicLayoutEngine.h
    ArabicShaping.h
    AttachmentPosnSubtables.h
    CanonShaping.h
    CharSubstitutionFilter.h
    ClassDefinitionTables.h
    ContextualGlyphInsertion.h
    ContextualGlyphInsertionProc2.h
    ContextualGlyphSubstitution.h
    ContextualGlyphSubstProc.h
    ContextualGlyphSubstProc2.h
    ContextualSubstSubtables.h
    CoverageTables.h
    CursiveAttachmentSubtables.h
    DefaultCharMapper.h
    DeviceTables.h
    ExtensionSubtables.h
    GDEFMarkFilter.h
    GlyphDefinitionTables.h
    GlyphIterator.h
    GlyphLookupTables.h
    GlyphPositionAdjustments.h
    GlyphPositioningTables.h
    GlyphPosnLookupProc.h
    GlyphSubstitutionTables.h
    GlyphSubstLookupProc.h
    GXLayoutEngine.h
    GXLayoutEngine2.h
    HangulLayoutEngine.h
    HanLayoutEngine.h
    ICUFeatures.h
    IndicLayoutEngine.h
    IndicRearrangement.h
    IndicRearrangementProcessor.h
    IndicRearrangementProcessor2.h
    IndicReordering.h
    KernTable.h
    KhmerLayoutEngine.h
    KhmerReordering.h
    LayoutTables.h
    LigatureSubstitution.h
    LigatureSubstProc.h
    LigatureSubstProc2.h
    LigatureSubstSubtables.h
    LookupProcessor.h
    Lookups.h
    LookupTables.h
    MarkArrays.h
    MarkToBasePosnSubtables.h
    MarkToLigaturePosnSubtables.h
    MarkToMarkPosnSubtables.h
    MorphStateTables.h
    MorphTables.h
    MPreFixups.h
    MultipleSubstSubtables.h
    NonContextualGlyphSubst.h
    NonContextualGlyphSubstProc.h
    NonContextualGlyphSubstProc2.h
    OpenTypeLayoutEngine.h
    OpenTypeTables.h
    OpenTypeUtilities.h
    PairPositioningSubtables.h
    ScriptAndLanguage.h
    ScriptAndLanguageTags.h
    SegmentArrayProcessor.h
    SegmentArrayProcessor2.h
    SegmentSingleProcessor.h
    SegmentSingleProcessor2.h
    SimpleArrayProcessor.h
    SimpleArrayProcessor2.h
    SinglePositioningSubtables.h
    SingleSubstitutionSubtables.h
    SingleTableProcessor.h
    SingleTableProcessor2.h
    StateTableProcessor.h
    StateTableProcessor2.h
    StateTables.h
    SubstitutionLookups.h
    SubtableProcessor.h
    SubtableProcessor2.h
    ThaiLayoutEngine.h
    ThaiShaping.h
    TibetanLayoutEngine.h
    TibetanReordering.h
    TrimmedArrayProcessor.h
    TrimmedArrayProcessor2.h
    ValueRecords.h
    )

SOURCE_GROUP("Source Files" FILES ${ICULE_SOURCE_FILES})
SOURCE_GROUP("Header Files" FILES ${ICULE_HEADER_FILES})

SET_SOURCE_FILES_PROPERTIES(ICULE_HEADER_FILES
                            PROPERTIES HEADER_FILE_ONLY TRUE)
LIST(APPEND ICULE_SOURCE_FILES ${ICULE_HEADER_FILES})

ADD_DEFINITIONS(
    -DU_LAYOUT_IMPLEMENTATION
)

ADD_LIBRARY(icule SHARED ${ICULE_SOURCE_FILES} )
TARGET_LINK_LIBRARIES(icule icuuc)

INSTALL(TARGETS icule
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
INSTALL(FILES ${ICULE_HEADER_FILES} DESTINATION "${INSTALL_INC_DIR}/layout")
