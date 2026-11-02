
# Automotive Power MOSFET – Electrical & Thermal Analysis

MATLAB-based analysis of conduction losses and temperature-dependent on-state resistance in automotive power MOSFETs.

## 1. Project Overview

This project investigates the influence of drain current and junction temperature on the conduction losses of automotive power MOSFETs.

The project includes:
- Conduction loss analysis at different drain currents
- Temperature-dependent on-state resistance modeling
- Comparison of linear and exponential temperature models
- Evaluation of conduction losses at elevated temperatures

The Infineon IAUC100N08S5N034 automotive MOSFET is used as a component reference.

**Note:** The temperature models use an illustrative coefficient and have not yet been validated against device-specific datasheet measurements.

## 2. Mathematical Models

### Conduction Loss

MOSFET conduction losses are calculated using:

**P_cond = I_D² × R_DS(on)**

Where:
- P_cond: Conduction loss [W]
- I_D: Drain current [A]
- R_DS(on): On-state resistance [Ohm]

### Linear Temperature Model

**R(T) = R_25 × [1 + α × (T − 25)]**

### Exponential Temperature Model

**R(T) = R_25 × (1 + α)^(T − 25)**

Where:
- R(T): On-state resistance at temperature T
- R_25: Reference resistance at 25°C
- α: Assumed temperature coefficient (0.004 K^-1)
- T: Junction temperature [°C]

For the component-reference analysis, the following parameters are used:

| Parameter | Value |
|---|---|
| MOSFET | Infineon IAUC100N08S5N034 |
| Reference on-state resistance | 3.4 mOhm |
| Assumed temperature coefficient | 0.004 K^-1 |
| Reference temperature | 25 deg C |
| Drain current | 40 A |
| Temperature range | 25–150 deg C |

The reference resistance is based on a specified maximum on-state resistance value. The temperature coefficient is an illustrative assumption, not a device-specific fitted parameter.

## 3. Simulation Results

### 3.1 Conduction Loss vs Drain Current

![Conduction Loss vs Current](mosfet_current_loss.png)

The initial model uses a constant on-state resistance of 10 mOhm.

Conduction losses increase quadratically with drain current. Doubling the current results in four times the conduction loss when resistance remains constant.

### 3.2 Conduction Loss vs Temperature

![Conduction Loss vs Temperature](mosfet_temperature_loss.png)

The initial simplified model uses a reference resistance of 10 mOhm and a constant drain current of 40 A.

The linear temperature model predicts an increase in conduction loss from 16 W at 25 deg C to 24 W at 150 deg C.

### 3.3 Temperature-Dependent Resistance Comparison

![Resistance Model Comparison](mosfet_resistance_comparison.png)

Using a reference resistance of 3.4 mOhm, both linear and exponential temperature models predict increasing on-state resistance.

The exponential model predicts a progressively higher resistance at elevated temperatures.

### 3.4 Conduction Loss Model Comparison

![Power Loss Comparison](mosfet_power_loss_comparison.png)

At a constant drain current of 40 A, the predicted conduction losses at 150 deg C are:

| Model | Resistance | Conduction Loss |
|---|---:|---:|
| Linear | 5.10 mOhm | 8.16 W |
| Exponential | 5.60 mOhm | 8.96 W |

At 150 deg C, the exponential model predicts approximately 9.8% higher conduction losses than the linear model.

## 4. MATLAB Files

### mosfet_conduction_analysis.m

Implements the initial conduction loss model and evaluates the influence of drain current and junction temperature using an illustrative 10 mOhm reference resistance.

### mosfet_datasheet_analysis.m

Uses a component-reference resistance of 3.4 mOhm and compares linear and exponential temperature-dependent resistance and conduction loss models.

## 5. Tools and Technologies

- MATLAB
- Git and GitHub
- Power semiconductor fundamentals
- Electrical loss modeling
- Temperature-dependent resistance analysis

## 6. Assumptions and Limitations

- The MOSFET is assumed to operate in the fully enhanced on-state.
- The conduction loss equation assumes continuous DC current.
- Switching losses are not included.
- Junction temperature is an independent input and is not calculated using a thermal network.
- Temperature coefficients are illustrative rather than extracted from device-specific measurements.
- The component-reference resistance is used under simplified operating assumptions.
- Thermal limits, safe operating area, and continuous-current capability are not evaluated.
- The results are analytical model predictions, not experimental measurements.

## 7. Future Development

Planned improvements include:

1. Extracting temperature-dependent resistance data from the manufacturer datasheet.
2. Comparing the simplified models with manufacturer characteristics.
3. Implementing a simplified electrothermal model.
4. Investigating the influence of cooling conditions and thermal resistance.
5. Extending the analysis to additional automotive MOSFET operating conditions.

## 8. References

Infineon Technologies – IAUC100N08S5N034 Automotive Power MOSFET

https://www.infineon.com/part/IAUC100N08S5N034

---

**Project status:** Work in progress – MATLAB model development and preliminary temperature comparison completed.
