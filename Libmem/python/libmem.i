%module pyLibmem

%ignore LM_DeepPointer;
%ignore LM_DeepPointerEx;

%include "typemaps.i"
%include "std_vector.i"
%include "carrays.i" 
%feature("python:annotations", "c");
%feature("threads", "1");
%feature("autodoc", "2");
%feature("c++", "1");
%feature("addextern", "1");
%feature("copyctor", "1");
%feature("except", "1");
%define LM_CALL %enddef
%feature("directors", "1");
%feature("valuewrapper", "1");
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
%}
%{
    #include <Python.h>
    #include <structmember.h>
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
%typemap(in) lm_ullong_t, lm_uint64_t, lm_time_t, lm_uintmax_t, lm_qword_t{
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
%typemap(out) lm_size_t {$result = PyLong_FromSsize_t($1);}
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
%template(ProcessList) std::vector<lm_process_t>;
%template(ThreadList) std::vector<lm_thread_t>;
%template(ModuleList) std::vector<lm_module_t>;
%template(PageList) std::vector<lm_page_t>;
%template(SymbolList) std::vector<lm_symbol_t>;
%template(InstructionList) std::vector<lm_inst_t>;
%template(VmtEntryList) std::vector<lm_vmt_entry_t>;
%template(VmtList) std::vector<lm_vmt_t>;


%rename (__lm_freedemanglesymbol) LM_FreeDemangleSymbol;
%rename (__lm_freeinstructions) LM_FreeInstructions;
%rename (__lm_freecodebuffer) LM_FreeCodeBuffer;
%rename (__isprocessalive) LM_IsProcessAlive;
%rename (__getprocess) LM_GetProcess;
%rename (__getprocessex) LM_GetProcessEx;
%rename (__findprocess) LM_FindProcess;
%rename (__getthread) LM_GetThread;
%rename (__getthreadex) LM_GetThreadEx;
%rename (__findmodule) LM_FindModule;
%rename (__findmoduleex) LM_FindModuleEx;
%rename (__getpage) LM_GetPage;
%rename (__getpageex) LM_GetPageEx;
%rename (__enumprocesses) LM_EnumProcesses;
%rename (__enumprocessesex) LM_EnumProcessesEx;
%rename (__enumthreads) LM_EnumThreads;
%rename (__enumthreadsex) LM_EnumThreadsEx;
%rename (__enummodules) LM_EnumModules;
%rename (__enummodulesex) LM_EnumModulesEx;
%rename (__enumpages) LM_EnumPages;
%rename (__enumpagesex) LM_EnumPagesEx;
%rename (__enumsymbols) LM_EnumSymbols;
%rename (__enumsymbolsdemangled) LM_EnumSymbolsDemangled;
%rename(__getsystembits) LM_GetSystemBits;
%rename(__getthreadprocess) LM_GetThreadProcess;
%rename(__loadmodule) LM_LoadModule;
%rename(__loadmoduleex) LM_LoadModuleEx;
%rename(__unloadmodule) LM_UnloadModule;
%rename(__unloadmoduleex) LM_UnloadModuleEx;
%rename(__findsymboladdress) LM_FindSymbolAddress;
%rename(__demanglesymbol) LM_DemangleSymbol;
%rename(__findsymboladdressdemangled) LM_FindSymbolAddressDemangled;
%rename(__readmemory) LM_ReadMemory;
%rename(__readmemoryex) LM_ReadMemoryEx;
%rename(__writememory) LM_WriteMemory;
%rename(__writememoryex) LM_WriteMemoryEx;
%rename(__setmemory) LM_SetMemory;
%rename(__setmemoryex) LM_SetMemoryEx;
%rename(__protmemory) LM_ProtMemory;
%rename(__protmemoryex) LM_ProtMemoryEx;
%rename(__allocmemory) LM_AllocMemory;
%rename(__allocmemoryex) LM_AllocMemoryEx;
%rename(__freememory) LM_FreeMemory;
%rename(__freememoryex) LM_FreeMemoryEx;
%rename(__datascan) LM_DataScan;
%rename(__datascanex) LM_DataScanEx;
%rename(__patternscan) LM_PatternScan;
%rename(__patternscanex) LM_PatternScanEx;
%rename(__sigscan) LM_SigScan;
%rename(__sigscanex) LM_SigScanEx;
%rename(__hookcode) LM_HookCode;
%rename(__hookcodeex) LM_HookCodeEx;
%rename(__unhookcode) LM_UnhookCode;
%rename(__unhookcodeex) LM_UnhookCodeEx;
%rename(__assemble) LM_Assemble;
%rename(__assembleex) LM_AssembleEx;
%rename(__disassemble) LM_Disassemble;
%rename(__disassembleex) LM_DisassembleEx;
%rename(__codelength) LM_CodeLength;
%rename(__codelengthex) LM_CodeLengthEx;
%rename(__vmtnew) LM_VmtNew;
%rename(__vmthook) LM_VmtHook;
%rename(__vmtunhook) LM_VmtUnhook;
%rename(__vmtgetoriginal) LM_VmtGetOriginal;
%rename(__vmtreset) LM_VmtReset;
%rename(__vmtfree) LM_VmtFree;

%include "libmem/libmem.h"

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
%inline %{
    lm_bool_t lm_is_process_alive(const lm_process_t *process) {
        return LM_IsProcessAlive(process);}

    lm_size_t lm_get_system_bits() {
        return LM_GetSystemBits();}
    lm_process_t lm_get_thread_process(const lm_thread_t *thread) {
        lm_process_t proc;
        LM_GetThreadProcess(thread, &proc);
        return proc;}
    lm_module_t lm_loadmodule(lm_string_t path) {
        lm_module_t mod;
        LM_LoadModule(path, &mod);
        return mod;}
    lm_module_t lm_loadmoduleex(const lm_process_t *process, lm_string_t path) {
        lm_module_t mod;
        LM_LoadModuleEx(process, path, &mod);
        return mod;}
    lm_bool_t lm_unloadmodule(lm_module_t *pmod) {
        return LM_UnloadModule(pmod);}
    lm_bool_t lm_unloadmoduleex(const lm_process_t *process, lm_module_t *pmod) {
        return LM_UnloadModuleEx(process, pmod);}
    lm_address_t lm_find_symbol_address(const lm_module_t *pmod, lm_cstring_t name) {
        return LM_FindSymbolAddress(pmod, name);}
    lm_cstring_t lm_demanglesymbol(lm_cstring_t symbol) {
        lm_size_t maxsize = 512;
        char* demangled = (char*)malloc(maxsize * sizeof(char));
        if (!demangled) {
            return NULL;
        }
        LM_DemangleSymbol(symbol, demangled, maxsize);
        return demangled;}
    lm_address_t lm_find_symbol_address_demangled(const lm_module_t *pmod, lm_cstring_t name) {
        return LM_FindSymbolAddressDemangled(pmod, name);}
    PyObject* lm_readmemory(lm_address_t src, lm_size_t size) {
        if (src == LM_ADDRESS_BAD || size == 0) {
            Py_RETURN_NONE;
        }

        lm_byte_t* dst = (lm_byte_t*)malloc(size);
        if (!dst) {
            PyErr_NoMemory();
            return NULL;
        }

        lm_size_t read = LM_ReadMemory(src, dst, size);
        if (read != size) {
            free(dst);
            Py_RETURN_NONE;
        }

        PyObject* result = PyByteArray_FromStringAndSize((const char*)dst, size);
        free(dst);
        return result;
    }
    PyObject* lm_readmemoryex(const lm_process_t *pproc, lm_address_t src, lm_size_t size) {
        if (!pproc || !LM_VALID_PROCESS(pproc) || src == LM_ADDRESS_BAD || size == 0) {
            Py_RETURN_NONE;
        }

        lm_byte_t* dst = (lm_byte_t*)malloc(size);
        if (!dst) {
            PyErr_NoMemory();
            return NULL;
        }

        lm_size_t read = LM_ReadMemoryEx(pproc, src, dst, size);
        if (read != size) {
            free(dst);
            Py_RETURN_NONE;
        }

        PyObject* result = PyByteArray_FromStringAndSize((const char*)dst, size);
        free(dst);
        return result;
        }
    PyObject* lm_writememory(lm_address_t dst, lm_bytearr_t src, lm_size_t size) {
        if (dst == LM_ADDRESS_BAD || size == 0) {
            Py_RETURN_NONE;
        }

        lm_size_t written = LM_WriteMemory(dst, src, size);
        if (written != size) {
            Py_RETURN_NONE;
        }

        Py_RETURN_TRUE;
    }
    PyObject* lm_writememoryex(const lm_process_t *pproc, lm_address_t dst, lm_bytearr_t src, lm_size_t size) {
        if (!pproc || !LM_VALID_PROCESS(pproc) || dst == LM_ADDRESS_BAD || size == 0) {
            Py_RETURN_NONE;
        }

        lm_size_t written = LM_WriteMemoryEx(pproc, dst, src, size);
        if (written != size) {
            Py_RETURN_NONE;
        }

        Py_RETURN_TRUE;
        }

    lm_size_t lm_setmemory(lm_address_t dst, lm_byte_t byte, lm_size_t size) {
        if (dst == LM_ADDRESS_BAD || size == 0) {
            return (lm_size_t)0;
        }

        lm_size_t written = LM_SetMemory(dst, byte, size);
        if (written != size) {
            return (lm_size_t)0;
        }

        return written;
    }

    lm_size_t lm_setmemoryex(const lm_process_t *pproc, lm_address_t dst, lm_byte_t byte, lm_size_t size) {
        if (!pproc || !LM_VALID_PROCESS(pproc) || dst == LM_ADDRESS_BAD || size == 0) {
            return (lm_size_t)0;
        }

        lm_size_t written = LM_SetMemoryEx(pproc, dst, byte, size);
        if (written != size) {
            return (lm_size_t)0;
        }

        return written;
        }

    lm_prot_t lm_protmemory(lm_address_t addr, lm_size_t size, lm_prot_t prot) {
        lm_prot_t oldprot;
        lm_bool_t result = LM_ProtMemory(addr, size, prot, &oldprot);

        if (result == LM_FALSE) {
            return (lm_prot_t)0;
        } else {
            return oldprot; }}
    lm_prot_t lm_protmemoryex(const lm_process_t *process, lm_address_t addr, lm_size_t size, lm_prot_t prot) {
        lm_prot_t oldprot;
        lm_bool_t result = LM_ProtMemoryEx(process, addr, size, prot, &oldprot);
        if (result == LM_FALSE) {
            return (lm_prot_t)0;
        } else {
            return oldprot; }}
    lm_address_t lm_allocmemory(lm_size_t size, lm_prot_t prot) {
        return LM_AllocMemory(size, prot);}
    lm_address_t lm_allocmemoryex(const lm_process_t *process, lm_size_t size, lm_prot_t prot) {
        return LM_AllocMemoryEx(process, size, prot);}
    lm_bool_t lm_freememory(lm_address_t alloc, lm_size_t size) {
        return LM_FreeMemory(alloc, size);}
    lm_bool_t lm_freememoryex(const lm_process_t *process, lm_address_t alloc, lm_size_t size) {
        return LM_FreeMemoryEx(process, alloc, size);}
    lm_address_t lm_patternscan(lm_bytearr_t pattern, lm_string_t mask, lm_address_t addr, lm_size_t scansize) {
        PyObject *pypattern;
        lm_address_t scan_match;
        pattern = (lm_bytearr_t)&pypattern;
        mask = (lm_string_t)PyBytes_AsString(pypattern);
        scan_match = LM_PatternScan(pattern, mask, addr, scansize);
        if (scan_match == LM_ADDRESS_BAD)
            return LM_ADDRESS_BAD;
        return scan_match;}
    lm_address_t lm_patternscanex(const lm_process_t *pproc, lm_bytearr_t pattern, lm_string_t mask, lm_address_t addr, lm_size_t scansize) {
        PyObject *pypattern;
        lm_address_t scan_match;
        lm_process_t *process = (lm_process_t *)pproc;
        pattern = (lm_bytearr_t)&pypattern;
        mask = (lm_string_t)PyBytes_AsString(pypattern);
        scan_match = LM_PatternScanEx(pproc, pattern, mask, addr, scansize);
        if (scan_match == LM_ADDRESS_BAD)
            return LM_ADDRESS_BAD;
        return scan_match;}
    lm_address_t lm_sigscan(lm_string_t sig, lm_address_t addr, lm_size_t scansize) {
        lm_address_t result = LM_SigScan(sig, addr, scansize);
        return result == (lm_address_t)LM_ADDRESS_BAD ? (lm_address_t)0 : result;}
    lm_address_t lm_sigscanex(const lm_process_t *pproc, lm_string_t sig, lm_address_t addr, lm_size_t scansize) {
        lm_address_t result = LM_SigScanEx(pproc, sig, addr, scansize);
        return result == (lm_address_t)LM_ADDRESS_BAD ? (lm_address_t)0 : result;}
     static PyObject *  lm_hookcode(lm_address_t from, lm_address_t to) {
        lm_address_t trampoline;
        lm_size_t    size;
        size = LM_HookCode(from, to, &trampoline);
        return Py_BuildValue("(nn)", trampoline, size);}
    static PyObject * lm_hookcodeex(const lm_process_t *pproc, lm_address_t from, lm_address_t to) {
        lm_address_t trampoline;
        lm_size_t    size;
        lm_process_t *process = (lm_process_t *)pproc;
        size = LM_HookCodeEx(pproc, from, to, &trampoline);
        return Py_BuildValue("(nn)", trampoline, size); }
    lm_bool_t lm_unhookcode(lm_address_t from, lm_address_t trampoline,lm_size_t    size ){
            if (!LM_UnhookCode(from, trampoline, size))
                return LM_FALSE;

            return LM_TRUE;}
    lm_bool_t lm_unhookcodeex(lm_process_t *pproc,lm_address_t from, lm_address_t trampoline,lm_size_t    size ){
            lm_process_t *proc = (lm_process_t *)pproc;
            if (!LM_UnhookCodeEx(proc, from, trampoline, size))
                return LM_FALSE;

            return LM_TRUE;}
    lm_size_t lm_codelength(lm_address_t code, lm_size_t minlength) {
        lm_size_t length = LM_CodeLength(code, minlength);
        if (length == 0) {
            return (lm_size_t)0; }
        return length;}
    lm_size_t lm_codelengthex(lm_process_t *pproc, lm_address_t code, lm_size_t minlength) {
        lm_size_t length = LM_CodeLengthEx(pproc, code, minlength);
        if (length == 0) {
            return (lm_size_t)0;}
        return length;}
/*     lm_void_t lm_vmtnew(lm_address_t *vtable,lm_vmt_t *pvmt) {
        lm_vmt_t *vmt = (lm_vmt_t *)pvmt;
        lm_address_t *vtab = (lm_address_t *)vtable;
        lm_address_t result = reinterpret_cast<lm_address_t>(LM_VmtNew(vtab));
        return result;}
        
       
    lm_bool_t lm_vmthook(lm_vmt_t *pvmt, lm_size_t fnindex, lm_address_t dst) {
        lm_vmt_t *vmt = (lm_vmt_t *)pvmt;
        return LM_VmtHook(vmt, fnindex, dst);}
    void lm_vmtunhook(lm_vmt_t *pvmt, lm_size_t fnindex) {
        lm_vmt_t *vmt = (lm_vmt_t *)pvmt;
        LM_VmtUnhook(vmt, fnindex);}
    lm_address_t lm_vmtgetoriginal(const lm_vmt_t *pvmt, lm_size_t fnindex) {
        lm_vmt_t *vmt = (lm_vmt_t *)pvmt;
        return LM_VmtGetOriginal(vmt, fnindex);}
    void lm_vmtreset(lm_vmt_t *pvmt) {
        lm_vmt_t *vmt = (lm_vmt_t *)pvmt;
        LM_VmtReset(vmt);}
    void lm_vmtfree(lm_vmt_t *pvmt) { */
/*         lm_vmt_t *vmt = (lm_vmt_t *)pvmt;
        LM_VmtFree(vmt);} */
%}


