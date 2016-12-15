/**
 * @file server/lobby/src/ManagerPacketInternal.cpp
 * @ingroup lobby
 *
 * @author HACKfrost
 *
 * @brief Manager to handle internal lobby packets.
 *
 * This file is part of the lobby Server (lobby).
 *
 * Copyright (C) 2012-2016 COMP_hack Team <compomega@tutanota.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "ManagerPacketInternal.h"

// libcomp includes
#include <PacketCodes.h>

// lobby Includes
#include "PacketParser.h"
#include "Packets.h"

using namespace lobby;

ManagerPacketInternal::ManagerPacketInternal(const std::shared_ptr<libcomp::BaseServer>& server)
    : ManagerPacket(server)
{
    mPacketParsers[PACKET_SET_WORLD_DESCRIPTION] = std::shared_ptr<PacketParser>(
        new Parsers::SetWorldDescription());
    mPacketParsers[PACKET_SET_CHANNEL_DESCRIPTION] = std::shared_ptr<PacketParser>(
        new Parsers::SetChannelDescription());
}

ManagerPacketInternal::~ManagerPacketInternal()
{
}