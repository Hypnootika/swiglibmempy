%module(directors=1) pyLibmem


%include "typemaps.i"
%include "std_vector.i"

%feature("python:annotations", "c");
%feature("threads", "1");
%feature("autodoc", "2");
%feature("c++", "1");
%feature("addextern", "1");
%feature("director", "1");
%define LM_CALL %enddef
%define PyObject_HEAD PyObject ob_base;%enddef
%{
#include <Python.h>
#include <structmember.h>
#include <vector>
#include <string>
#include <algorithm>
#include <functional>
#include <cctype>
#include <locale>
#if LM_COMPATIBLE
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    #include <stdint.h>
    #include <string.h>
    #include <ctype.h>
    #include <assert.h>
    #include <cstdlib>
#if LM_OS == LM_OS_WIN
    #	include <windows.h>
#else
    #	include <sys/types.h>
    #	include <sys/mman.h> /* Protection flags */
    #	include <unistd.h>
    #	include <limits.h>
#endif /* LM_OS */
#endif /* LM_COMPATIBLE */
#include "libmem/libmem.h"
%}

%inline %{
    
    typedef char               lm_cchar_t;
    typedef unsigned char      lm_uchar_t;
    typedef int                lm_int_t;
    typedef unsigned int       lm_uint_t;
    typedef short              lm_short_t;
    typedef unsigned short     lm_ushort_t;
    typedef long               lm_long_t;
    typedef unsigned long      lm_ulong_t;
    typedef long long          lm_llong_t;
    typedef unsigned long long lm_ullong_t;
    typedef wchar_t            lm_wchar_t;
    typedef void               lm_void_t;
    typedef lm_int_t           lm_bool_t;
    typedef intmax_t           lm_intmax_t;
    typedef uintmax_t          lm_uintmax_t;
    typedef int8_t             lm_int8_t;
    typedef int16_t            lm_int16_t;
    typedef int32_t            lm_int32_t;
    typedef int64_t            lm_int64_t;
    typedef uint8_t            lm_uint8_t;
    typedef uint16_t           lm_uint16_t;
    typedef uint32_t           lm_uint32_t;
    typedef uint64_t           lm_uint64_t;
    typedef lm_uint8_t         lm_byte_t;
    typedef lm_uint16_t        lm_word_t;
    typedef lm_uint32_t        lm_dword_t;
    typedef lm_uint64_t        lm_qword_t;
    typedef intptr_t           lm_intptr_t;
    typedef uintptr_t          lm_uintptr_t;
    typedef lm_uintptr_t      lm_address_t;
    typedef lm_uintmax_t       lm_size_t;
    typedef lm_uint32_t        lm_pid_t;
    typedef lm_uint32_t        lm_tid_t;
    typedef lm_uint64_t        lm_time_t;
    typedef lm_cchar_t         lm_char_t;
    typedef const lm_byte_t   *lm_bytearr_t;
    typedef const lm_cchar_t  *lm_cstring_t;
    typedef const lm_wchar_t  *lm_wstring_t;
    typedef const lm_char_t   *lm_string_t;
    #define LM_MALLOC   malloc
    #define LM_CALLOC   calloc
    #define LM_REALLOC  realloc
    #define LM_FREE     free
    #define LM_MEMCMP   memcmp
    #define LM_MEMCPY   memcpy
    #define LM_MEMSET   memset
    #define LM_ASSERT   assert
    #define LM_FOPEN    fopen
    #define LM_FCLOSE   fclose
    #define LM_GETLINE  getline
    #define LM_PATH_MAX 512
%}

%typemap(typecheck, precedence=SWIG_TYPECHECK_INTEGER) lm_pid_t, lm_prot_t, lm_size_t, lm_uint64_t, lm_time_t, lm_uintmax_t, lm_address_t, lm_byte_t{
    $1 = PyLong_Check($input);}
%typemap(typecheck, precedence=SWIG_TYPECHECK_STRING) lm_string_t, lm_cstring_t{
    $1 = PyUnicode_Check($input);}

%typemap(typecheck, precedence=SWIG_TYPECHECK_STRING) lm_bytearr_t{
    $1 = PyBytes_Check($input);}
%typemap(in) lm_uint64_t, lm_time_t, lm_uintmax_t, lm_address_t{
    if (!PyLong_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected an integer");
        return NULL;
    }
    $1 = ($1_type)PyLong_AsUnsignedLongLong($input);}
%typemap(in) lm_size_t {
    if (!PyLong_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected an integer");
        return NULL;
    }
    $1 = ($1_type)PyLong_AsSsize_t($input);}
%typemap(in) lm_uint8_t, lm_uint16_t, lm_uint32_t, lm_pid_t, lm_tid_t, lm_prot_t, lm_byte_t{
    if (!PyLong_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected an integer");
        return NULL;
    }
    $1 = ($1_type)PyLong_AsUnsignedLong($input);}

   
%typemap(in) lm_voidptr_t{
    if (!PyLong_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected an integer for pointer");
        return NULL;
    }
    $1 = ($1_type)PyLong_AsVoidPtr($input);}
%typemap(in) lm_string_t, lm_cstring_t{
    if (!PyUnicode_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected a string object");
        return NULL;
    }
    wchar_t *str = PyUnicode_AsWideCharString($input, NULL);
    $1 = (const lm_char_t *)str;
    PyMem_Free(str);}
%typemap(in) lm_bytearr_t {
    if (!PyBytes_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Expected a bytes object");
        return NULL;
    }
    $1 = (const lm_byte_t *)PyBytes_AsString($input);}

%typemap(out) lm_uint8_t, lm_uint16_t, lm_uint32_t, lm_pid_t, lm_tid_t, lm_prot_t, lm_byte_t{$result = PyLong_FromUnsignedLong($1);}
%typemap(out) lm_uint64_t, lm_time_t, lm_uintmax_t , lm_address_t{$result = PyLong_FromUnsignedLongLong($1);}
%typemap(out) lm_voidptr_t {$result = PyLong_FromVoidPtr($1);}
%typemap(out) lm_bytearr_t {$result = PyBytes_FromString((const char *)$1);}
%typemap(out) lm_string_t, lm_cstring_t {$result = PyUnicode_FromString($1);}
%typemap(out) lm_size_t {$result = PyLong_FromSsize_t($1);}
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
%template(ProcessList) std::vector<lm_process_t>;
%template(ThreadList) std::vector<lm_thread_t>;
%template(ModuleList) std::vector<lm_module_t>;
%template(PageList) std::vector<lm_page_t>;
%template(SymbolList) std::vector<lm_symbol_t>;
%template(InstructionList) std::vector<lm_inst_t>;
%template(VmtEntryList) std::vector<lm_vmt_entry_t>;
%template(VmtList) std::vector<lm_vmt_t>;

%rename("%(regex:/^LM_([A-Za-z0-9_]+)/__\\1/)s", %$isfunction) "";



%inline %{
    std::vector<lm_process_t> lm_enumprocesses() {
        std::vector<lm_process_t> processes;
        auto callback = [](lm_process_t *process, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_process_t>* procList = (std::vector<lm_process_t>*)arg;
            procList->push_back(*process);
            return 1;
        };
        LM_EnumProcesses(callback, &processes);
        return processes;
        }
    std::vector<lm_thread_t> lm_enumthreads() {
        std::vector<lm_thread_t> threads;
        auto callback = [](lm_thread_t *pthread, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_thread_t>* threadList = (std::vector<lm_thread_t>*)arg;
            threadList->push_back(*pthread);
            return 1;
        };
        LM_EnumThreads(callback, &threads);
        return threads;}
    std::vector<lm_thread_t> lm_enumthreads(const lm_process_t *process) {
        std::vector<lm_thread_t> threads;
        auto callback = [](lm_thread_t *pthread, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_thread_t>* threadList = (std::vector<lm_thread_t>*)arg;
            threadList->push_back(*pthread);
            return 1;
        };
        if (process != nullptr) {
            LM_EnumThreadsEx(process, callback, &threads);
        } else {
            LM_EnumThreads(callback, &threads);
        }
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
    std::vector<lm_module_t> lm_enummodules(const lm_process_t *process) {
        std::vector<lm_module_t> modules;
        auto callback = [](lm_module_t *pmodule, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_module_t>* moduleList = (std::vector<lm_module_t>*)arg;
            moduleList->push_back(*pmodule);
            return 1;
        };
        if (process != nullptr) {
            LM_EnumModulesEx(process, callback, &modules);
        } else {
            LM_EnumModules(callback, &modules);
        }
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
    std::vector<lm_page_t> lm_enumpages(const lm_process_t *process) {
        std::vector<lm_page_t> pages;
        auto callback = [](lm_page_t *ppage, lm_void_t *arg) -> lm_bool_t {
            std::vector<lm_page_t>* pageList = (std::vector<lm_page_t>*)arg;
            pageList->push_back(*ppage);
            return 1;
        };

        if (process != nullptr) {
            LM_EnumPagesEx(process, callback, &pages);
        } else {
            LM_EnumPages(callback, &pages);
        }
        return pages;}
    lm_process_t lm_get_process(){
        lm_process_t proc;
        LM_GetProcess(&proc);
        return proc;}
    lm_process_t lm_get_process(lm_pid_t pid){
        lm_process_t proc;
        LM_GetProcessEx(pid, &proc);
        return proc;}
    lm_process_t lm_get_process(lm_char_t *name){
        lm_process_t proc;
        LM_FindProcess(name, &proc);
        return proc;}
    lm_module_t lm_get_module(lm_char_t *name) {
        lm_module_t mod;
        LM_FindModule(name, &mod);
        return mod;}
    lm_module_t lm_get_module(const lm_process_t *process, lm_char_t *name) {
        lm_module_t mod;
        LM_FindModuleEx(process, name, &mod);
        return mod;}

    lm_page_t lm_get_page(lm_address_t address) {
        lm_page_t page;
        LM_GetPage(address, &page);
        return page;}
    lm_page_t lm_get_page(const lm_process_t *process, lm_address_t address) {
        lm_page_t page;
        LM_GetPageEx(process, address, &page);
        return page;}

    lm_thread_t lm_get_thread() {
        lm_thread_t thread;
        LM_GetThread(&thread);
        return thread;}
    lm_thread_t lm_get_thread(const lm_process_t *process) {
        lm_thread_t thread;
        LM_GetThreadEx(process, &thread);
        return thread;}

    lm_bool_t lm_is_process_alive(const lm_process_t *process = nullptr) {
        if (process == nullptr) {
            lm_process_t cur_process = lm_get_process();
            lm_bool_t result = LM_IsProcessAlive(&cur_process);
            return result;
        } else {
            lm_bool_t result =  LM_IsProcessAlive(process);
            return result;
        }}
    lm_size_t lm_get_system_bits() {
        return LM_GetSystemBits();}
    lm_process_t lm_get_thread_process(const lm_thread_t *thread = nullptr) {
        lm_process_t proc;
        if (!thread) {
            lm_thread_t thread = lm_get_thread();
            proc = lm_get_thread_process(&thread);
            return proc;}
        LM_GetThreadProcess(thread, &proc);
        return proc;}
    lm_module_t lm_loadmodule( lm_string_t path) {
        lm_module_t mod;
        LM_LoadModule(path, &mod);
        return mod;}
    lm_module_t lm_loadmodule(const lm_process_t *process, lm_string_t path) {
        lm_module_t mod;
        LM_LoadModuleEx(process, path, &mod);
        return mod;}
    lm_bool_t lm_unloadmodule(lm_module_t *pmod) {
        return LM_UnloadModule(pmod);}
    lm_bool_t lm_unloadmodule(const lm_process_t *process, lm_module_t *pmod) {
        return LM_UnloadModuleEx(process, pmod);}
    lm_byte_t* lm_readmemory(lm_address_t src, lm_size_t size) {
        lm_byte_t* dst = (lm_byte_t*)malloc(size);
        if (!dst) {
            return NULL;
        }
        lm_size_t read_size = LM_ReadMemory(src, dst, size);
        if (read_size != size) {
            free(dst);
            return NULL; }
        return dst;}
    lm_byte_t* lm_readmemory(const lm_process_t *process, lm_address_t src, lm_size_t size) {
        lm_byte_t* dst = (lm_byte_t*)malloc(size);
        if (!dst) {
            return NULL;
        }
        lm_size_t read_size = LM_ReadMemoryEx(process, src, dst, size);
        if (read_size != size) {
            free(dst);
            return NULL; }
        return dst; }
    PyObject* lm_writememory(lm_address_t dst, lm_bytearr_t src, lm_size_t size, const lm_process_t *pproc = nullptr) {
        if ((!pproc && dst == LM_ADDRESS_BAD) || size == 0 || (pproc && !LM_VALID_PROCESS(pproc))) {
            Py_RETURN_NONE;
        }
        lm_size_t written = pproc ? LM_WriteMemoryEx(pproc, dst, src, size) : LM_WriteMemory(dst, src, size);
        if (written != size) {
            Py_RETURN_NONE;
        }
        Py_RETURN_TRUE;}

    lm_size_t lm_setmemory(lm_address_t dst, lm_byte_t byte, lm_size_t size, const lm_process_t *pproc = nullptr) {
        if ((!pproc && dst == LM_ADDRESS_BAD) || size == 0 || (pproc && !LM_VALID_PROCESS(pproc))) {
            return (lm_size_t)0;
        }
        lm_size_t written = pproc ? LM_SetMemoryEx(pproc, dst, byte, size) : LM_SetMemory(dst, byte, size);
        if (written != size) {
            return (lm_size_t)0;
        }
        return written;}
    lm_prot_t lm_protmemory(lm_address_t addr, lm_size_t size, lm_prot_t prot, const lm_process_t *process = nullptr) {
        lm_prot_t oldprot;
        lm_bool_t result = process ? LM_ProtMemoryEx(process, addr, size, prot, &oldprot) : LM_ProtMemory(addr, size, prot, &oldprot);
        return result == LM_FALSE ? (lm_prot_t)0 : oldprot;}
    lm_address_t lm_allocmemory(lm_size_t size, lm_prot_t prot, const lm_process_t *process = nullptr) {
        return process ? LM_AllocMemoryEx(process, size, prot) : LM_AllocMemory(size, prot);}
    lm_bool_t lm_freememory(lm_address_t alloc, lm_size_t size, const lm_process_t *process = nullptr) {
        return process ? LM_FreeMemoryEx(process, alloc, size) : LM_FreeMemory(alloc, size);}
    lm_address_t lm_patternscan(lm_bytearr_t pattern, lm_string_t mask, lm_address_t addr, lm_size_t scansize, const lm_process_t *pproc = nullptr) {
        return pproc ? LM_PatternScanEx(pproc, pattern, mask, addr, scansize) : LM_PatternScan(pattern, mask, addr, scansize);}
    lm_address_t lm_sigscan(lm_string_t sig, lm_address_t addr, lm_size_t scansize, const lm_process_t *pproc = nullptr) {
        return pproc ? LM_SigScanEx(pproc, sig, addr, scansize) : LM_SigScan(sig, addr, scansize);}
     static PyObject *  lm_hookcode(lm_address_t from, lm_address_t to) {
        lm_address_t trampoline;
        lm_size_t    size;
        size = LM_HookCode(from, to, &trampoline);
        return Py_BuildValue("(nn)", trampoline, size);}
    static PyObject * lm_hookcodeex(lm_address_t from, lm_address_t to, lm_process_t *pproc = nullptr) {
        lm_address_t trampoline;
        lm_size_t size = pproc ? LM_HookCodeEx(pproc, from, to, &trampoline) : LM_HookCode(from, to, &trampoline);
        return Py_BuildValue("(nn)", trampoline, size);}
    lm_bool_t lm_unhookcode(lm_address_t from, lm_address_t trampoline, lm_size_t size, const lm_process_t *pproc = nullptr) {
        return pproc ? LM_UnhookCodeEx(pproc, from, trampoline, size) : LM_UnhookCode(from, trampoline, size) ? LM_TRUE : LM_FALSE;}
    lm_size_t lm_codelength(lm_address_t code, lm_size_t minlength, lm_process_t *pproc = nullptr) {
        return pproc ? LM_CodeLengthEx(pproc, code, minlength) : LM_CodeLength(code, minlength);}
%}
%include "libmem/libmem.h"