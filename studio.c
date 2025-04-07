// studio.c
#include <windows.h>
#include <commdlg.h>
#include <stdio.h>
#include <stdlib.h>
#include "studio.h"

void open_and_play_video() {
    char filename[MAX_PATH] = "";

    OPENFILENAME ofn;
    ZeroMemory(&ofn, sizeof(ofn));

    ofn.lStructSize = sizeof(ofn);
    ofn.lpstrFile = filename;
    ofn.nMaxFile = sizeof(filename);
    ofn.lpstrFilter = "Video Files\0*.MP4;*.AVI;*.MKV;*.MOV\0All Files\0*.*\0";
    ofn.nFilterIndex = 1;
    ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST;

    if (GetOpenFileName(&ofn)) {
        // 🔥 Path to VLC (adjust if needed)
        const char* vlc_path = "\"C:\\Program_*
