{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 1,
   "metadata": {},
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\u001b[32m\u001b[1m    Updating\u001b[22m\u001b[39m registry at `~/.julia/registries/General.toml`\n",
      "\u001b[32m\u001b[1m   Resolving\u001b[22m\u001b[39m package versions...\n",
      "\u001b[32m\u001b[1m  No Changes\u001b[22m\u001b[39m to `~/.julia/environments/v1.8/Project.toml`\n",
      "\u001b[32m\u001b[1m  No Changes\u001b[22m\u001b[39m to `~/.julia/environments/v1.8/Manifest.toml`\n",
      "\u001b[32m\u001b[1m   Resolving\u001b[22m\u001b[39m package versions...\n",
      "\u001b[32m\u001b[1m  No Changes\u001b[22m\u001b[39m to `~/.julia/environments/v1.8/Project.toml`\n",
      "\u001b[32m\u001b[1m  No Changes\u001b[22m\u001b[39m to `~/.julia/environments/v1.8/Manifest.toml`\n",
      "\u001b[32m\u001b[1m   Resolving\u001b[22m\u001b[39m package versions...\n",
      "\u001b[32m\u001b[1m  No Changes\u001b[22m\u001b[39m to `~/.julia/environments/v1.8/Project.toml`\n",
      "\u001b[32m\u001b[1m  No Changes\u001b[22m\u001b[39m to `~/.julia/environments/v1.8/Manifest.toml`\n",
      "\u001b[32m\u001b[1m   Resolving\u001b[22m\u001b[39m package versions...\n",
      "\u001b[32m\u001b[1m  No Changes\u001b[22m\u001b[39m to `~/.julia/environments/v1.8/Project.toml`\n",
      "\u001b[32m\u001b[1m  No Changes\u001b[22m\u001b[39m to `~/.julia/environments/v1.8/Manifest.toml`\n"
     ]
    }
   ],
   "source": [
    "using Pkg\n",
    "Pkg.instantiate()\n",
    "Pkg.add(\"CSV\")\n",
    "Pkg.add(\"DataFrames\")\n",
    "Pkg.add(\"Distributions\")\n",
    "Pkg.add(\"Unitful\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "metadata": {},
   "outputs": [],
   "source": [
    "using CSV\n",
    "using DataFrames\n",
    "using Random, Distributions\n",
    "using Unitful"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "2-element Vector{Union{Nothing, typeof(sim_step!)}}:\n",
       " sim_step! (generic function with 3 methods)\n",
       " nothing"
      ]
     },
     "execution_count": 2,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "include.(filter(contains(r\".jl$\"), readdir(\"CorticalModel\"; join=true)))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "NeuronNet(Dict{String, NeuronPopulation}(), Dict{Tuple{String, String}, AbstractArray}())"
      ]
     },
     "execution_count": 3,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "net = NeuronNet()"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "Dict{String, Int64} with 8 entries:\n",
       "  \"5I\"   => 2736\n",
       "  \"4I\"   => 540\n",
       "  \"6I\"   => 1476\n",
       "  \"2/3I\" => 2916\n",
       "  \"4E\"   => 2412\n",
       "  \"2/3E\" => 10332\n",
       "  \"5E\"   => 10944\n",
       "  \"6E\"   => 7200"
      ]
     },
     "execution_count": 4,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "l_name = [\"2/3E\", \"2/3I\", \"4E\", \"4I\", \"5E\", \"5I\", \"6E\", \"6I\"]\n",
    "x = [1148, 324, 268, 60, 1216, 304, 800, 164, 657]\n",
    "n_layer = [i * 9 for i in x]\n",
    "n_layer_dict = Dict(zip(l_name, n_layer))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/html": [
       "<div><div style = \"float: left;\"><span>54×10 DataFrame</span></div><div style = \"float: right;\"><span style = \"font-style: italic;\">29 rows omitted</span></div><div style = \"clear: both;\"></div></div><div class = \"data-frame\" style = \"overflow-x: scroll;\"><table class = \"data-frame\" style = \"margin-bottom: 6px;\"><thead><tr class = \"header\"><th class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">Row</th><th style = \"text-align: left;\">Source</th><th style = \"text-align: left;\">SourceType</th><th style = \"text-align: left;\">Target</th><th style = \"text-align: left;\">TargetType</th><th style = \"text-align: left;\">Pmax</th><th style = \"text-align: left;\">Radius</th><th style = \"text-align: left;\">Weight</th><th style = \"text-align: left;\">Wstd</th><th style = \"text-align: left;\">Delay</th><th style = \"text-align: left;\">Dstd</th></tr><tr class = \"subheader headerLastRow\"><th class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\"></th><th title = \"String3\" style = \"text-align: left;\">String3</th><th title = \"String1\" style = \"text-align: left;\">String1</th><th title = \"String3\" style = \"text-align: left;\">String3</th><th title = \"String1\" style = \"text-align: left;\">String1</th><th title = \"Float64\" style = \"text-align: left;\">Float64</th><th title = \"Float64\" style = \"text-align: left;\">Float64</th><th title = \"String15\" style = \"text-align: left;\">String15</th><th title = \"String7\" style = \"text-align: left;\">String7</th><th title = \"Float64\" style = \"text-align: left;\">Float64</th><th title = \"Float64\" style = \"text-align: left;\">Float64</th></tr></thead><tbody><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">1</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.192</td><td style = \"text-align: right;\">0.0003</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">2</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">I</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.3095</td><td style = \"text-align: right;\">0.000175</td><td style = \"text-align: left;\">-351.2*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">0.8</td><td style = \"text-align: right;\">0.4</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">3</td><td style = \"text-align: left;\">4</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.3356</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">175.6*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">4</td><td style = \"text-align: left;\">4</td><td style = \"text-align: left;\">I</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.5802</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">-351.2*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">0.8</td><td style = \"text-align: right;\">0.4</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">5</td><td style = \"text-align: left;\">5</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.0143</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">6</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.0159</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">7</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.252</td><td style = \"text-align: right;\">0.0003</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">8</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">I</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.2553</td><td style = \"text-align: right;\">0.000175</td><td style = \"text-align: left;\">-351.2*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">0.8</td><td style = \"text-align: right;\">0.4</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">9</td><td style = \"text-align: left;\">4</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.2558</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">10</td><td style = \"text-align: left;\">4</td><td style = \"text-align: left;\">I</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.4183</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">-351.2*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">0.8</td><td style = \"text-align: right;\">0.4</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">11</td><td style = \"text-align: left;\">5</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.034</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">12</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.008</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">13</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">4</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.016</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td style = \"text-align: right;\">&vellip;</td><td style = \"text-align: right;\">&vellip;</td><td style = \"text-align: right;\">&vellip;</td><td style = \"text-align: right;\">&vellip;</td><td style = \"text-align: right;\">&vellip;</td><td style = \"text-align: right;\">&vellip;</td><td style = \"text-align: right;\">&vellip;</td><td style = \"text-align: right;\">&vellip;</td><td style = \"text-align: right;\">&vellip;</td><td style = \"text-align: right;\">&vellip;</td><td style = \"text-align: right;\">&vellip;</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">43</td><td style = \"text-align: left;\">5</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.0257</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">44</td><td style = \"text-align: left;\">5</td><td style = \"text-align: left;\">I</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.0078</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">-351.2*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">0.8</td><td style = \"text-align: right;\">0.4</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">45</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.0784</td><td style = \"text-align: right;\">0.000225</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">46</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">I</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">E</td><td style = \"text-align: right;\">0.399</td><td style = \"text-align: right;\">0.000175</td><td style = \"text-align: left;\">-351.2*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">0.8</td><td style = \"text-align: right;\">0.4</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">47</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.0708</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">48</td><td style = \"text-align: left;\">2/3</td><td style = \"text-align: left;\">I</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.002</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">-351.2*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">0.8</td><td style = \"text-align: right;\">0.4</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">49</td><td style = \"text-align: left;\">4</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.0269</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">50</td><td style = \"text-align: left;\">4</td><td style = \"text-align: left;\">I</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.0101</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">-351.2*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">0.8</td><td style = \"text-align: right;\">0.4</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">51</td><td style = \"text-align: left;\">5</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.0125</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">52</td><td style = \"text-align: left;\">5</td><td style = \"text-align: left;\">I</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.0031</td><td style = \"text-align: right;\">5.0e-5</td><td style = \"text-align: left;\">-351.2*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">0.8</td><td style = \"text-align: right;\">0.4</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">53</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">E</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.1276</td><td style = \"text-align: right;\">0.000225</td><td style = \"text-align: left;\">87.8*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">1.5</td><td style = \"text-align: right;\">0.75</td></tr><tr><td class = \"rowNumber\" style = \"font-weight: bold; text-align: right;\">54</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">I</td><td style = \"text-align: left;\">6</td><td style = \"text-align: left;\">I</td><td style = \"text-align: right;\">0.267</td><td style = \"text-align: right;\">0.000175</td><td style = \"text-align: left;\">-351.2*pA</td><td style = \"text-align: left;\">8.78*pA</td><td style = \"text-align: right;\">0.8</td><td style = \"text-align: right;\">0.4</td></tr></tbody></table></div>"
      ],
      "text/latex": [
       "\\begin{tabular}{r|ccccccccc}\n",
       "\t& Source & SourceType & Target & TargetType & Pmax & Radius & Weight & Wstd & \\\\\n",
       "\t\\hline\n",
       "\t& String3 & String1 & String3 & String1 & Float64 & Float64 & String15 & String7 & \\\\\n",
       "\t\\hline\n",
       "\t1 & 2/3 & E & 2/3 & E & 0.192 & 0.0003 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t2 & 2/3 & I & 2/3 & E & 0.3095 & 0.000175 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t3 & 4 & E & 2/3 & E & 0.3356 & 5.0e-5 & 175.6*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t4 & 4 & I & 2/3 & E & 0.5802 & 5.0e-5 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t5 & 5 & E & 2/3 & E & 0.0143 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t6 & 6 & E & 2/3 & E & 0.0159 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t7 & 2/3 & E & 2/3 & I & 0.252 & 0.0003 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t8 & 2/3 & I & 2/3 & I & 0.2553 & 0.000175 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t9 & 4 & E & 2/3 & I & 0.2558 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t10 & 4 & I & 2/3 & I & 0.4183 & 5.0e-5 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t11 & 5 & E & 2/3 & I & 0.034 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t12 & 6 & E & 2/3 & I & 0.008 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t13 & 2/3 & E & 4 & E & 0.016 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t14 & 2/3 & I & 4 & E & 0.012 & 5.0e-5 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t15 & 4 & E & 4 & E & 0.3725 & 0.0003 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t16 & 4 & I & 4 & E & 0.7704 & 0.000175 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t17 & 5 & E & 4 & E & 0.0031 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t18 & 6 & E & 4 & E & 0.0879 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t19 & 2/3 & E & 4 & I & 0.1334 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t20 & 2/3 & I & 4 & I & 0.006 & 5.0e-5 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t21 & 4 & E & 4 & I & 0.5266 & 0.0003 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t22 & 4 & I & 4 & I & 0.8295 & 0.000175 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t23 & 5 & E & 4 & I & 0.0013 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t24 & 6 & E & 4 & I & 0.2007 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t25 & 2/3 & E & 5 & E & 0.1902 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t26 & 2/3 & I & 5 & E & 0.1202 & 5.0e-5 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t27 & 4 & E & 5 & E & 0.3785 & 5.0e-5 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t28 & 4 & I & 5 & E & 0.0592 & 5.0e-5 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t29 & 5 & E & 5 & E & 0.0377 & 0.0003 & 87.8*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t30 & 5 & I & 5 & E & 0.1662 & 0.000175 & -351.2*pA & 8.78*pA & $\\dots$ \\\\\n",
       "\t$\\dots$ & $\\dots$ & $\\dots$ & $\\dots$ & $\\dots$ & $\\dots$ & $\\dots$ & $\\dots$ & $\\dots$ &  \\\\\n",
       "\\end{tabular}\n"
      ],
      "text/plain": [
       "\u001b[1m54×10 DataFrame\u001b[0m\n",
       "\u001b[1m Row \u001b[0m│\u001b[1m Source  \u001b[0m\u001b[1m SourceType \u001b[0m\u001b[1m Target  \u001b[0m\u001b[1m TargetType \u001b[0m\u001b[1m Pmax    \u001b[0m\u001b[1m Radius   \u001b[0m\u001b[1m Weight    \u001b[0m\u001b[1m\u001b[0m ⋯\n",
       "     │\u001b[90m String3 \u001b[0m\u001b[90m String1    \u001b[0m\u001b[90m String3 \u001b[0m\u001b[90m String1    \u001b[0m\u001b[90m Float64 \u001b[0m\u001b[90m Float64  \u001b[0m\u001b[90m String15  \u001b[0m\u001b[90m\u001b[0m ⋯\n",
       "─────┼──────────────────────────────────────────────────────────────────────────\n",
       "   1 │ 2/3      E           2/3      E            0.192   0.0003    87.8*pA    ⋯\n",
       "   2 │ 2/3      I           2/3      E            0.3095  0.000175  -351.2*pA\n",
       "   3 │ 4        E           2/3      E            0.3356  5.0e-5    175.6*pA\n",
       "   4 │ 4        I           2/3      E            0.5802  5.0e-5    -351.2*pA\n",
       "   5 │ 5        E           2/3      E            0.0143  5.0e-5    87.8*pA    ⋯\n",
       "   6 │ 6        E           2/3      E            0.0159  5.0e-5    87.8*pA\n",
       "   7 │ 2/3      E           2/3      I            0.252   0.0003    87.8*pA\n",
       "   8 │ 2/3      I           2/3      I            0.2553  0.000175  -351.2*pA\n",
       "   9 │ 4        E           2/3      I            0.2558  5.0e-5    87.8*pA    ⋯\n",
       "  10 │ 4        I           2/3      I            0.4183  5.0e-5    -351.2*pA\n",
       "  11 │ 5        E           2/3      I            0.034   5.0e-5    87.8*pA\n",
       "  ⋮  │    ⋮         ⋮          ⋮         ⋮          ⋮        ⋮          ⋮      ⋱\n",
       "  45 │ 6        E           6        E            0.0784  0.000225  87.8*pA\n",
       "  46 │ 6        I           6        E            0.399   0.000175  -351.2*pA  ⋯\n",
       "  47 │ 2/3      E           6        I            0.0708  5.0e-5    87.8*pA\n",
       "  48 │ 2/3      I           6        I            0.002   5.0e-5    -351.2*pA\n",
       "  49 │ 4        E           6        I            0.0269  5.0e-5    87.8*pA\n",
       "  50 │ 4        I           6        I            0.0101  5.0e-5    -351.2*pA  ⋯\n",
       "  51 │ 5        E           6        I            0.0125  5.0e-5    87.8*pA\n",
       "  52 │ 5        I           6        I            0.0031  5.0e-5    -351.2*pA\n",
       "  53 │ 6        E           6        I            0.1276  0.000225  87.8*pA\n",
       "  54 │ 6        I           6        I            0.267   0.000175  -351.2*pA  ⋯\n",
       "\u001b[36m                                                   3 columns and 33 rows omitted\u001b[0m"
      ]
     },
     "execution_count": 5,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "df = DataFrame(CSV.File(\"shimoura11_spatial.csv\"))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 35,
   "metadata": {},
   "outputs": [],
   "source": [
    "### Create synapse weight matrices\n",
    "pA = 1\n",
    "num_conn = size(df)[1]\n",
    "for row_n in 1:num_conn\n",
    "    src = df[row_n,:].Source*df[row_n,:].SourceType\n",
    "    tgt = df[row_n,:].Target*df[row_n,:].TargetType\n",
    "    #println(src, \" to \", tgt)\n",
    "    prob = df[row_n,:].Pmax\n",
    "    nsyn = round(Int, log(1.0-prob)/log(1.0 - (1.0/(n_layer_dict[src]*n_layer_dict[tgt]))))\n",
    "    #println(\"Num Syn:\", nsyn)\n",
    "    src_idx = rand(1:n_layer_dict[src], nsyn)\n",
    "    tgt_idx = rand(1:n_layer_dict[tgt], nsyn)\n",
    "    #pA = u\"pA\"\n",
    "    Weight = eval(Meta.parse(df[row_n,:].Weight))\n",
    "    Wstd = eval(Meta.parse(df[row_n,:].Wstd))\n",
    "    d = Normal(ustrip(Weight), ustrip(Wstd))\n",
    "    weights=rand(d,nsyn) #* u\"pA\"\n",
    "    submatrix = Array{Float32, 2}(undef, n_layer_dict[src], n_layer_dict[tgt])\n",
    "    for i in 1:nsyn\n",
    "        submatrix[src_idx[i], tgt_idx[i]] = weights[i]\n",
    "    end\n",
    "    net.weights[(src, tgt)] = submatrix \n",
    "end"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 26,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "2412×10944 Matrix{Float32}:\n",
       "   0.0      0.0       0.0      0.0     …    0.0     88.0877   0.0\n",
       "   0.0     80.1452    0.0     83.13         0.0      0.0      0.0\n",
       "  82.686    0.0      99.5093   0.0        105.504    0.0      0.0\n",
       "   0.0      0.0       0.0     82.5614      73.7337   0.0      0.0\n",
       "   0.0      0.0       0.0      0.0        101.679    0.0      0.0\n",
       "   0.0     80.3254    0.0     97.2763  …    0.0      0.0      0.0\n",
       "   0.0      0.0       0.0      0.0          0.0     91.0646  91.692\n",
       "  92.2379   0.0       0.0      0.0          0.0     81.1962   0.0\n",
       "  74.3006  91.6567    0.0     84.4135      83.2374   0.0     72.9468\n",
       "   0.0     94.3816   69.9651  72.8166       0.0     88.9712   0.0\n",
       "   0.0     76.2045    0.0     88.941   …    0.0      0.0      0.0\n",
       "  80.2174   0.0       0.0      0.0          0.0      0.0     96.7923\n",
       "   0.0      0.0      88.6036   0.0         86.1171   0.0     93.3677\n",
       "   ⋮                                   ⋱                     \n",
       "   0.0     89.7849    0.0     74.3332  …    0.0      0.0      0.0\n",
       "   0.0      0.0       0.0      0.0          0.0      0.0      0.0\n",
       "   0.0     81.3756    0.0     86.5292       0.0     93.64    92.8602\n",
       "  90.9784  85.7397    0.0      0.0          0.0      0.0      0.0\n",
       "  86.1708   0.0     100.216   97.0173       0.0     92.5763  80.8641\n",
       " 105.685   86.4066    0.0      0.0     …   88.46     0.0      0.0\n",
       "  94.7191   0.0       0.0     87.1969       0.0      0.0     89.2665\n",
       "   0.0     77.2857   80.5692  80.077        0.0     84.0114   0.0\n",
       "  78.8863   0.0       0.0      0.0         84.2492   0.0     92.0939\n",
       "   0.0      0.0      87.751   89.6046      99.0329  82.4915   0.0\n",
       "  91.1003   0.0      94.2043  80.6282  …    0.0      0.0      0.0\n",
       "  89.5261   0.0       0.0      0.0         94.4732   0.0      0.0"
      ]
     },
     "execution_count": 26,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "net.weights[(\"4E\", \"5E\")]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "metadata": {},
   "outputs": [],
   "source": [
    "d_ex = 1.5e-3     \t# Excitatory delay\n",
    "std_d_ex = 0.75e-3 \t# Std. Excitatory delay\n",
    "d_in = 0.80e-3      # Inhibitory delay\n",
    "std_d_in = 0.4e-3  \t# Std. Inhibitory delay\n",
    "for (key, value) in n_layer_dict\n",
    "    if occursin(\"E\", key) == true\n",
    "        d = d_ex\n",
    "        d_std = std_d_ex\n",
    "        else occursin(\"I\", key) == true\n",
    "        d = d_in\n",
    "        d_std = std_d_in\n",
    "    end\n",
    "    a= Normal(d, d_std)\n",
    "    delays=Float32.(rand(a,n_layer_dict[key]))\n",
    "    net.pops[key] = NeuronPopulation(1e-4, abs.(delays))\n",
    "end"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 26,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "Dict{String, NeuronPopulation} with 8 entries:\n",
       "  \"5I\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[0.0 0.0 … …\n",
       "  \"4I\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[0.0 0.0 … …\n",
       "  \"6E\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[0.0 0.0 … …\n",
       "  \"2/3I\" => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[0.0 0.0 … …\n",
       "  \"4E\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[0.0 0.0 … …\n",
       "  \"2/3E\" => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[0.0 0.0 … …\n",
       "  \"6I\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[0.0 0.0 … …\n",
       "  \"5E\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[0.0 0.0 … …"
      ]
     },
     "execution_count": 26,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "net.pops"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "metadata": {},
   "outputs": [
    {
     "ename": "LoadError",
     "evalue": "KeyError: key (\"6I\", \"5I\") not found",
     "output_type": "error",
     "traceback": [
      "KeyError: key (\"6I\", \"5I\") not found",
      "",
      "Stacktrace:",
      " [1] getindex(h::Dict{Tuple{String, String}, AbstractArray}, key::Tuple{String, String})",
      "   @ Base ./dict.jl:498",
      " [2] top-level scope",
      "   @ In[14]:1",
      " [3] eval",
      "   @ ./boot.jl:368 [inlined]",
      " [4] include_string(mapexpr::typeof(REPL.softscope), mod::Module, code::String, filename::String)",
      "   @ Base ./loading.jl:1428"
     ]
    }
   ],
   "source": [
    "net.weights[(\"6I\",\"5I\")]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "activation! (generic function with 1 method)"
      ]
     },
     "execution_count": 8,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "function sim_step!(pop::NeuronPopulation, v::Vector{Float32}, weights::AbstractArray)\n",
    "  # update postsynaptic population given incident voltages\n",
    "\n",
    "  # calculate v_out\n",
    "  # v_out = your equation, including action potentials, ...\n",
    "  pop.v.buf[:,1] += weights*v\n",
    "end \n",
    "\n",
    "function activation!(pop::NeuronPopulation)\n",
    "   for i = 1:length(pop.delays)\n",
    "        if pop.v.buf[i,1] > firing_threshold\n",
    "            pop.v[i] = reset_v\n",
    "        end \n",
    "   end\n",
    "end"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "Dict{String, NeuronPopulation} with 8 entries:\n",
       "  \"5I\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[-0.06 -0.0…\n",
       "  \"4I\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[-0.06 NaN …\n",
       "  \"6I\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[-0.06 NaN …\n",
       "  \"2/3I\" => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[-0.06 NaN …\n",
       "  \"4E\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[-0.06 NaN …\n",
       "  \"2/3E\" => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[-0.06 NaN …\n",
       "  \"5E\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[-0.06 NaN …\n",
       "  \"6E\"   => NeuronPopulation(TemporalBuffer{Float32}(0.0001, Float32[-0.06 NaN …"
      ]
     },
     "execution_count": 16,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "firing_threshold = -55e-3\n",
    "reset_v = -60e-3\n",
    "sim_step!(net)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "10332×46 Matrix{Float32}:\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0  …  0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0  …  0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0  …  0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       "  ⋮                         ⋮         ⋱       ⋮                        ⋮\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0  …  0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0  …  0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0  …  0.0  0.0  0.0  0.0  0.0  0.0  0.0\n",
       " -0.06  NaN  NaN  0.0  0.0  0.0  0.0     0.0  0.0  0.0  0.0  0.0  0.0  0.0"
      ]
     },
     "execution_count": 17,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "net.pops[\"2/3E\"].v.buf"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 56,
   "metadata": {},
   "outputs": [
    {
     "ename": "LoadError",
     "evalue": "BoundsError: attempt to access 2736×22 Matrix{Float32} at index [1, 10000]",
     "output_type": "error",
     "traceback": [
      "BoundsError: attempt to access 2736×22 Matrix{Float32} at index [1, 10000]",
      "",
      "Stacktrace:",
      " [1] getindex(::Matrix{Float32}, ::Int64, ::Int64)",
      "   @ Base ./array.jl:925",
      " [2] getindex(tb::TemporalBuffer{Float32}, i::Int64, t::Float32)",
      "   @ Main ./In[56]:3",
      " [3] top-level scope",
      "   @ In[56]:5",
      " [4] eval",
      "   @ ./boot.jl:368 [inlined]",
      " [5] include_string(mapexpr::typeof(REPL.softscope), mod::Module, code::String, filename::String)",
      "   @ Base ./loading.jl:1428"
     ]
    }
   ],
   "source": [
    "net.pops[\"5I\"].v[1, 1.0f0]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Julia 1.8.2",
   "language": "julia",
   "name": "julia-1.8"
  },
  "language_info": {
   "file_extension": ".jl",
   "mimetype": "application/julia",
   "name": "julia",
   "version": "1.8.2"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
