@echo off
setlocal
cd /d "%~dp0"

title OBSERVATORIO - ETAPA 2

echo ============================================================
echo OBSERVATORIO - ETAPA 2
echo ============================================================
echo.

echo [09] EXTRAIR SELECAO DO DIA
py 09_extrair_selecao_do_dia.py --delta delta_14102026_EVENTOS.json --txt selecao_do_dia_14102026.txt --out enriquecido_14102026.json --debug selecao_nao_encontrados_14102026.json

REM O 09 pode retornar errorlevel por titulo nao encontrado.
REM So interrompe se o arquivo de saida nao existir.
if not exist enriquecido_14102026.json goto :erro09

echo.
echo ============================================================
echo 09 CONCLUIDO - CONTINUANDO PARA GERAR O INDEX DO DIA
echo ============================================================
echo.

echo [10] GERAR INDEX DO DIA
py 10_gerar_index_dia.py enriquecido_14102026.json --out index_dia_14102026.json
if errorlevel 1 goto :erro10
if not exist index_dia_14102026.json goto :erro10arquivo

echo.
echo ============================================================
echo 10 CONCLUIDO - ATUALIZANDO MASTER E NOTICIAS BLOG
echo ============================================================
echo.

echo [11] JUNTAR MASTER + BLOG500
echo IMPORTANTE: a partir daqui, qualquer erro ficara visivel.
echo.

py 11_juntar_master_BLOG500.py index_dia_14102026.json
set ERRO11=%ERRORLEVEL%

echo.
echo ============================================================
echo PASSO 11 TERMINOU COM ERRORLEVEL = %ERRO11%
echo ============================================================
echo.

if not "%ERRO11%"=="0" goto :erro11

echo PASSO 11 CONCLUIDO SEM ERRO REPORTADO.
echo.
echo Antes de fechar, confira acima se o script informou
echo a geracao/atualizacao do INDEX MASTER e do NOTICIAS BLOG.
echo.
pause

echo.
echo ============================================================
echo ETAPA 2 CONCLUIDA
echo MASTER E BLOG ATUALIZADOS
echo ============================================================
echo.
pause
goto :fim

:erro09
echo.
echo ============================================================
echo ERRO NO PASSO 09
echo enriquecido_14102026.json NAO FOI GERADO.
echo ============================================================
goto :erro

:erro10
echo.
echo ============================================================
echo ERRO NO PASSO 10 - GERAR INDEX DO DIA
echo O SCRIPT RETORNOU ERRORLEVEL MAIOR QUE ZERO.
echo ============================================================
goto :erro

:erro10arquivo
echo.
echo ============================================================
echo ERRO NO PASSO 10
echo index_dia_14102026.json NAO FOI GERADO.
echo ============================================================
goto :erro

:erro11
echo.
echo ============================================================
echo ERRO NO PASSO 11 - JUNTAR MASTER + BLOG500
echo ERRORLEVEL = %ERRO11%
echo VEJA A ULTIMA MENSAGEM DO PYTHON LOGO ACIMA.
echo ============================================================
goto :erro

:erro
echo.
echo ============================================================
echo O FLUXO FOI INTERROMPIDO.
echo ESTA JANELA NAO SERA FECHADA AUTOMATICAMENTE.
echo ============================================================
echo.
pause

:fim
endlocal
