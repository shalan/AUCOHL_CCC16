/*
	Copyright 2024 AUCOHL

	Author: Mohamed Shalan (mshalan@aucegypt.edu)

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	    http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

*/

#ifndef AUCOHL_CCC16REGS_H
#define AUCOHL_CCC16REGS_H

#ifndef IO_TYPES
#define IO_TYPES
#define   __R     volatile const unsigned int
#define   __W     volatile       unsigned int
#define   __RW    volatile       unsigned int
#endif

#define AUCOHL_CCC16_CTRL_REG_TE_BIT	0
#define AUCOHL_CCC16_CTRL_REG_TE_MASK	0x1
#define AUCOHL_CCC16_CTRL_REG_CE_BIT	1
#define AUCOHL_CCC16_CTRL_REG_CE_MASK	0x2
#define AUCOHL_CCC16_CTRL_REG_GFE_BIT	2
#define AUCOHL_CCC16_CTRL_REG_GFE_MASK	0x4
#define AUCOHL_CCC16_CTRL_REG_CCLR_BIT	3
#define AUCOHL_CCC16_CTRL_REG_CCLR_MASK	0x8
#define AUCOHL_CCC16_CFG_REG_GFL_BIT	0
#define AUCOHL_CCC16_CFG_REG_GFL_MASK	0xf
#define AUCOHL_CCC16_CFG_REG_CE_BIT	4
#define AUCOHL_CCC16_CFG_REG_CE_MASK	0x30
#define AUCOHL_CCC16_CFG_REG_CAPS_BIT	6
#define AUCOHL_CCC16_CFG_REG_CAPS_MASK	0xc0
#define AUCOHL_CCC16_CFG_REG_CAPE_BIT	8
#define AUCOHL_CCC16_CFG_REG_CAPE_MASK	0x300

#define AUCOHL_CCC16_CM_FLAG	0x1
#define AUCOHL_CCC16_CAP_FLAG	0x2

typedef struct _AUCOHL_CCC16_TYPE_ {
	__W 	PR;
	__W 	CCMP;
	__R 	CAP;
	__W 	CTRL;
	__W 	CFG;
	__R 	reserved[955];
	__RW	im;
	__R 	mis;
	__R 	ris;
	__W 	icr;
} AUCOHL_CCC16_TYPE;

#endif

