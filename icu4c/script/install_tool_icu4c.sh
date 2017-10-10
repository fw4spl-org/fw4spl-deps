path=${1}
version=${2}

install_name_tool -change libicuuc.${version}.dylib ${path}/libicuuc.${version}.dylib ${path}/libicui18n.${version}.dylib
install_name_tool -change libicuuc.${version}.dylib ${path}/libicuuc.${version}.dylib ${path}/libicuio.${version}.dylib
install_name_tool -change libicuuc.${version}.dylib ${path}/libicuuc.${version}.dylib ${path}/libicutu.${version}.dylib
install_name_tool -change libicuuc.${version}.dylib ${path}/libicuuc.${version}.dylib ${path}/libicutest.${version}.dylib
install_name_tool -change libicuuc.${version}.dylib ${path}/libicuuc.${version}.dylib ${path}/libiculx.${version}.dylib
install_name_tool -change libicuuc.${version}.dylib ${path}/libicuuc.${version}.dylib ${path}/libicule.${version}.dylib
install_name_tool -change libicudata.${version}.dylib ${path}/libicudata.${version}.dylib ${path}/libicuio.${version}.dylib
install_name_tool -change libicudata.${version}.dylib ${path}/libicudata.${version}.dylib ${path}/libicui18n.${version}.dylib
install_name_tool -change libicudata.${version}.dylib ${path}/libicudata.${version}.dylib ${path}/libicuuc.${version}.dylib
install_name_tool -change libicudata.${version}.dylib ${path}/libicudata.${version}.dylib ${path}/libicutu.${version}.dylib
install_name_tool -change libicudata.${version}.dylib ${path}/libicudata.${version}.dylib ${path}/libicutest.${version}.dylib
install_name_tool -change libicudata.${version}.dylib ${path}/libicudata.${version}.dylib ${path}/libiculx.${version}.dylib
install_name_tool -change libicudata.${version}.dylib ${path}/libicudata.${version}.dylib ${path}/libicule.${version}.dylib
install_name_tool -change libicui18n.${version}.dylib ${path}/libicui18n.${version}.dylib ${path}/libicuio.${version}.dylib
install_name_tool -change libicui18n.${version}.dylib ${path}/libicui18n.${version}.dylib ${path}/libicutu.${version}.dylib
install_name_tool -change libicui18n.${version}.dylib ${path}/libicui18n.${version}.dylib ${path}/libicutest.${version}.dylib
install_name_tool -change libicule.${version}.dylib ${path}/libicule.${version}.dylib ${path}/libiculx.${version}.dylib
install_name_tool -change libicutu.${version}.dylib ${path}/libicutu.${version}.dylib ${path}/libicutest.${version}.dylib
install_name_tool -id ${path}/libicui18n.${version}.dylib ${path}/libicui18n.${version}.dylib
install_name_tool -id ${path}/libicuio.${version}.dylib ${path}/libicuio.${version}.dylib
install_name_tool -id ${path}/libicuuc.${version}.dylib ${path}/libicuuc.${version}.dylib
install_name_tool -id ${path}/libicuuc.${version}.dylib ${path}/libicuuc.${version}.dylib
install_name_tool -id ${path}/libicudata.${version}.dylib ${path}/libicudata.${version}.dylib
install_name_tool -id ${path}/libicule.${version}.dylib ${path}/libicule.${version}.dylib
install_name_tool -id ${path}/libiculx.${version}.dylib ${path}/libiculx.${version}.dylib
install_name_tool -id ${path}/libicutest.${version}.dylib ${path}/libicutest.${version}.dylib
install_name_tool -id ${path}/libicutu.${version}.dylib ${path}/libicutu.${version}.dylib
install_name_tool -id ${path}/libicuuc.${version}.dylib ${path}/libicuuc.${version}.dylib

echo "-- install_name_tool script Done.\n"
