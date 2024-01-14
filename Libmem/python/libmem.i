%module pyLibmem

%ignore LM_DeepPointer;
%ignore LM_DeepPointerEx;

%include <inttypes.i>
%include <typemaps.i>
%include <std_common.i>
%include <std_string.i>
%include <std_vectora.i>
%include <std_map.i>
%include <std_pair.i>
%include <std_alloc.i>
%include <cdata.i>
%include <std_container.i>
%include <attribute.i>
%include <std_list.i>
%feature("python:annotations", "c");
%feature("threads", "1");
%feature("autodoc", "2");
%feature("c++", "1");
%feature("addextern", "1");
%feature("copyctor", "1");
%feature("except", "1");
%feature("directors", "1");
%feature("valuewrapper", "1");
%define LM_FORCE_OS_WIN %enddef
%define WIN32 %enddef
%define _M_AMD64 %enddef
%define _M_X64 %enddef
%define LM_FORCE_BITS_64 %enddef
%define LM_FORCE_COMPILER_MSVC %enddef
%define LM_FORCE_CHARSET_MB %enddef
%define LM_FORCE_LANG_CPP %enddef

%{
#include <Python.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>
#include <windows.h>
#include "libmem/libmem.h"
%}
%typemap(in) lm_short_t, lm_long_t, lm_int8_t, lm_int16_t, lm_int32_t {
    if (!PyLong_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected an integer");
        return NULL;
    }
    $1 = ($1_type)PyLong_AsLong($input);}
%typemap(in) lm_uint8_t, lm_uint16_t, lm_uint32_t, lm_pid_t, lm_tid_t, lm_prot_t, lm_ulong_t, lm_ushort_t, lm_byte_t, lm_word_t, lm_dword_t{
    if (!PyLong_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected an integer");
        return NULL;
    }
    $1 = ($1_type)PyLong_AsUnsignedLong($input);}
%typemap(in) lm_llong_t, lm_int64_t, lm_intmax_t {
    if (!PyLong_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected an integer");
        return NULL;
    }
    $1 = ($1_type)PyLong_AsLongLong($input);}
%typemap(in) lm_ullong_t, lm_uint64_t, lm_time_t, lm_uintmax_t, lm_qword_t, lm_size_t{
    if (!PyLong_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected an integer");
        return NULL;
    }
    $1 = ($1_type)PyLong_AsUnsignedLongLong($input);}
%typemap(in) lm_cchar_t, lm_uchar_t {
    if (!PyUnicode_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected a string");
        return NULL;
    }
    $1 = ($1_type)PyBytes_AsString($input);}
%typemap(in) lm_wchar_t {
    if (!PyUnicode_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected a unicode string");
        return NULL;
    }
    $1 = (lm_wchar_t *)PyUnicode_AsWideCharString($input, NULL);}
%typemap(in) lm_voidptr_t {
    if (!PyLong_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected an integer for void pointer");
        return NULL;
    }
    $1 = (lm_voidptr_t)PyLong_AsVoidPtr($input);}
%typemap(in) lm_intptr_t, lm_uintptr_t, lm_address_t {
    if (!PyLong_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected an integer for pointer");
        return NULL;
    }
    $1 = ($1_type)PyLong_AsVoidPtr($input);}
%typemap(in) lm_string_t, lm_cstring_t {
    if (!PyUnicode_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected a string");
        return NULL;
    }
    $1 = PyUnicode_AsUTF8($input);}
%typemap(in) lm_wstring_t {
    if (!PyUnicode_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected a unicode string");
        return NULL;
    }
    $1 = (const wchar_t *)PyUnicode_AsWideCharString($input, NULL);}

%typemap(in) lm_bytearr_t {
    if (!PyBytes_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected a bytes object");
        return NULL;
    }
    $1 = (const lm_byte_t *)PyBytes_AsString($input);}

%typemap(out) lm_wchar_t {$result = PyUnicode_FromWideChar($1, wcslen($1));}
%typemap(out) lm_int8_t, lm_int16_t, lm_int32_t, lm_long_t, lm_short_t,lm_int_t{$result = PyLong_FromLong($1);}
%typemap(out) lm_uint8_t, lm_uint16_t, lm_uint32_t, lm_pid_t, lm_tid_t, lm_prot_t, lm_ulong_t, lm_ushort_t, lm_byte_t, lm_word_t, lm_dword_t{$result = PyLong_FromUnsignedLong($1);}
%typemap(out) lm_uint64_t, lm_time_t, lm_uintmax_t, lm_ullong_t, lm_qword_t {$result = PyLong_FromUnsignedLongLong($1);}
%typemap(out) lm_int64_t, lm_intmax_t, lm_llong_t {$result = PyLong_FromLongLong($1);}
%typemap(out) lm_cchar_t, lm_uchar_t {$result = PyBytes_FromString((char*)$1);}
%typemap(out) lm_voidptr_t {$result = PyLong_FromVoidPtr($1);}
%typemap(out) lm_wstring_t {$result = PyUnicode_FromWideChar($1, wcslen($1));}
%typemap(out) lm_bytearr_t {$result = PyBytes_FromString((const char *)$1);}
%typemap(out) lm_string_t, lm_cstring_t {$result = PyBytes_FromString($1);}
%typemap(out) lm_intptr_t, lm_uintptr_t, lm_address_t {$result = PyLong_FromVoidPtr((void *)$1);}
%typemap(out) lm_size_t {$result = PyLong_FromSize_t($1);}
%typemap(out) lm_bool_t {$result = PyBool_FromLong($1);}
%extend lm_process_t {
    %pythoncode %{
        def __repr__(self):
            return f"lm_process_t(pid={self.pid}, ppid={self.ppid}, bits={self.bits}, start_time={self.start_time}, path={self.path}, name={self.name})"
    %}}
%extend lm_thread_t {
    %pythoncode %{
        def __repr__(self):
            return f"lm_thread_t(tid={self.tid})"
    %}}
%extend lm_module_t {
    %pythoncode %{
        def __repr__(self):
            return f"lm_module_t(base={self.base}, end={self.end}, size={self.size}, path={self.path}, name={self.name})"
    %}}
%extend lm_page_t {
    %pythoncode %{
        def __repr__(self):
            return f"lm_page_t(base={self.base}, end={self.end}, size={self.size}, prot={self.prot})"
    %}}
%extend lm_symbol_t {
    %pythoncode %{
        def __repr__(self):
            return f"lm_symbol_t(name={self.name}, address={self.address})"
    %}}
%extend lm_inst_t {
    %pythoncode %{
        def __repr__(self):
            return f"lm_inst_t(id={self.id}, address={self.address}, size={self.size}, bytes={self.bytes}, mnemonic={self.mnemonic}, op_str={self.op_str}, detail={self.detail})"
    %}}
%extend lm_vmt_entry_t {
    %pythoncode %{
        def __repr__(self):
            return f"lm_vmt_entry_t(orig_func={self.orig_func}, index={self.index}, next={self.next})"
    %}}
%extend lm_vmt_t {
    %pythoncode %{
        def __repr__(self):
            return f"lm_vmt_t(vtable={self.vtable}, hkentries={self.hkentries})"
    %}}


namespace std {
    %template(ProcessList) vector<lm_process_t>;
    %template(ThreadList) vector<lm_thread_t>;
    %template(ModuleList) vector<lm_module_t>;
    %template(PageList) vector<lm_page_t>;
    %template(SymbolList) vector<lm_symbol_t>;
    %template(InstructionList) vector<lm_inst_t>;
    %template(VmtEntryList) vector<lm_vmt_entry_t>;
    %template(VmtList) vector<lm_vmt_t>;
}

%inline %{
    std::vector<lm_process_t> lm_enumprocesses() {
        std::vector<lm_process_t> processes;
        auto callback = [](lm_process_t *process, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_process_t>* procList = (std::vector<lm_process_t>*)arg;
            procList->push_back(*process);
            return 1;
        };
        LM_EnumProcesses(callback, &processes);
        return processes;}
    std::vector<lm_thread_t> lm_enumthreads() {
        std::vector<lm_thread_t> threads;
        auto callback = [](lm_thread_t *pthread, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_thread_t>* threadList = (std::vector<lm_thread_t>*)arg;
            threadList->push_back(*pthread);
            return 1;
        };
        LM_EnumThreads(callback, &threads);
        return threads;}
    std::vector<lm_thread_t> lm_enumthreadsex(const lm_process_t *process) {
        std::vector<lm_thread_t> threads;
        auto callback = [](lm_thread_t *pthr, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_thread_t>* thrList = (std::vector<lm_thread_t>*)arg;
            thrList->push_back(*pthr);
            return 1;
        };

        LM_EnumThreadsEx(process, callback, &threads);
        return threads;}
    std::vector<lm_module_t> lm_enummodules() {
        std::vector<lm_module_t> modules;
        auto callback = [](lm_module_t *pmodule, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_module_t>* moduleList = (std::vector<lm_module_t>*)arg;
            moduleList->push_back(*pmodule);
            return 1;
        };
        LM_EnumModules(callback, &modules);
        return modules;}
    std::vector<lm_module_t> lm_enummodulesex(const lm_process_t *process) {
        std::vector<lm_module_t> modules;
        auto callback = [](lm_module_t *pmod, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_module_t>* modList = (std::vector<lm_module_t>*)arg;
            modList->push_back(*pmod);
            return 1;
        };
        LM_EnumModulesEx(process, callback, &modules);
        return modules;}

    std::vector<lm_page_t> lm_enumpages() {
        std::vector<lm_page_t> pages;
        auto callback = [](lm_page_t *ppage, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_page_t>* pageList = (std::vector<lm_page_t>*)arg;
            pageList->push_back(*ppage);
            return 1;
        };

        LM_EnumPages(callback, &pages);
        return pages;}

    std::vector<lm_page_t> lm_enumpagesex(const lm_process_t *process) {
        std::vector<lm_page_t> pages;
        auto callback = [](lm_page_t *ppage, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_page_t>* pageList = (std::vector<lm_page_t>*)arg;
            pageList->push_back(*ppage);
            return 1;
        };

        LM_EnumPagesEx(process, callback, &pages);
        return pages;}
    
    std::vector<lm_symbol_t> lm_enumsymbols(const lm_module_t *module) {
        std::vector<lm_symbol_t> symbols;
        auto callback = [](lm_symbol_t *psymbol, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_symbol_t>* symbolList = (std::vector<lm_symbol_t>*)arg;
            symbolList->push_back(*psymbol);
            return 1;
        };

        LM_EnumSymbols(module, callback, &symbols);
        return symbols;}
    std::vector<lm_symbol_t> lm_enumsymbols_demangled(const lm_module_t *module) {
        std::vector<lm_symbol_t> symbols;
        auto callback = [](lm_symbol_t *psymbol, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_symbol_t>* symbolList = (std::vector<lm_symbol_t>*)arg;
            symbolList->push_back(*psymbol);
            return 1;
        };

        LM_EnumSymbolsDemangled(module, callback, &symbols);
        return symbols;}
%}

%inline %{
    lm_process_t lm_get_process() {
        lm_process_t process;
        LM_GetProcess(&process);
    return process;
    }
    lm_process_t lm_get_process_ex(lm_pid_t pid) {
        lm_process_t process;
        LM_GetProcessEx(pid, &process);
    return process;
    }
    lm_process_t lm_find_process(lm_string_t name) {
        lm_process_t process;
        LM_FindProcess(name, &process);
    return process;
    }
    lm_thread_t lm_get_thread() {
        lm_thread_t thread;
        LM_GetThread(&thread);
    return thread;
    }
    lm_thread_t lm_get_thread_ex(const lm_process_t *process) {
        lm_thread_t thread;
        LM_GetThreadEx(process, &thread);
    return thread;
    }
    lm_module_t lm_get_module(lm_string_t name) {
        lm_module_t mod;
        LM_FindModule(name, &mod);
    return mod;
    }
    lm_module_t lm_get_module_ex(const lm_process_t *process, lm_string_t name) {
        lm_module_t mod;
        LM_FindModuleEx(process, name, &mod);
    return mod;
    }
    lm_page_t lm_get_page(lm_address_t address) {
        lm_page_t page;
        LM_GetPage(address, &page);
    return page;
    }
    lm_page_t lm_get_page_ex(const lm_process_t *process, lm_address_t address) {
        lm_page_t page;
        LM_GetPageEx(process, address, &page);
    return page;
    }
%}


%ignore LM_GetProcess;
%include "libmem/libmem.h"
